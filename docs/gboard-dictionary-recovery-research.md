# Google Pinyin / Gboard mutable-dictionary recovery audit

## Scope

This audit reviews Google Pinyin 4.5.2 mutable-dictionary persistence and the Compatibility v20 recovery layer against:

- the original `DictionaryAccessor.persist()` rotation;
- `AbstractHmmEngineFactory.enrollMutableDictionary()` startup enrollment;
- `SaveDictionaryTask` scheduling and forced lifecycle saves;
- explicit user deletion/clear operations;
- the current Gboard implementations represented by `gkf`, `gkk`, and `gld` in the local research decode;
- the live Compatibility package data captured on 2026-07-24.

The relevant mutable files are the main file plus optional `_bak`, `_tmp`, and `_unreadable` sidecars.

## Live-device state

The rooted Pixel 10 Pro data was exported read-only from:

`/data/user/0/com.google.android.inputmethod.pinyin.compat`

The snapshot is stored under `work/dictionary-current-20260724/`. The live state is healthy:

- every expected main dictionary exists;
- all five dictionaries currently covered by rolling persistence have a `_bak`;
- every current main/backup pair is byte-identical;
- no `_tmp` or `_unreadable` file exists;
- logcat contains no enrollment, unreadable-file, or recovery failure;
- native user-dictionary export succeeds and returns 339 entries (336 Chinese rows and 3 English rows).

This confirms that the current implementation is operating normally, but does not by itself prove every interrupted-rotation path.

## Original Google Pinyin persistence

`DictionaryAccessor.persist()` performs the following sequence:

1. Delete a stale `_tmp`.
2. Ask the native mutable-dictionary accessor to persist into `_tmp`.
3. If a main file exists, delete the previous `_bak`.
4. Rename main to `_bak`.
5. Rename `_tmp` to main.
6. In the original build, delete `_bak` immediately after success.
7. On errors, delete `_tmp` and restore `_bak` only when main is absent.

The rename-based rotation is locally atomic, but deleting `_bak` after success means there is normally no durable previous version. A process death between the two renames can leave main absent even though `_bak` and possibly `_tmp` exist.

## Compatibility v20 behavior

Compatibility v20 made two deliberate changes:

- the successful persistence path retains `_bak`;
- enrollment calls `DictionaryRecoveryCompat` before load and after a native load failure.

Current startup order:

1. If main exists, load it.
2. If main is absent, rename `_bak` to main.
3. If no backup can be restored, rename `_tmp` to main.
4. If native enrollment fails, archive main as `_unreadable`, restore `_bak`, and retry once.
5. If no backup can be restored, enroll an empty mutable dictionary.

This closes the original high-risk interrupted-rename window and is consistent with the healthy live-device state.

## Current Gboard comparison

### Enrollment

Current Gboard `gkf.H()` opens an existing file and asks `DataManagerImpl.nativeEnrollMutableDictFd()` to enroll it. `gkf.w()` falls back to `nativeEnrollEmptyMutableDict()` when that returns false. The inspected implementation does not itself search `_bak` or `_tmp` after enrollment failure.

Therefore Compatibility v20 recovery is intentionally stronger than the directly visible current Gboard enrollment path; it should not be removed merely to match Gboard.

### Persistence

Current Gboard `gkk.b()` still uses the same broad `_tmp` -> main and main -> `_bak` rotation. After a successful replacement it deletes `_bak`, so it does not provide the retained rolling copy used by this compatibility project.

One notable modern behavior is that Gboard deletes the old main file before persisting a dictionary whose native size is zero. This avoids retaining pre-clear contents through a normal empty-dictionary save.

### Save serialization

Current Gboard `gld.run()` synchronizes the save operation on the task class. It also tracks per-engine futures and allows a synchronous lifecycle save to wait up to five seconds for an outstanding task.

Google Pinyin uses `AsyncTask` plus a `Set` to suppress duplicate scheduled tasks, but `saveDictionaryNow()` bypasses that set and executes synchronously. A rapid lifecycle transition can therefore overlap a scheduled save with a forced save. Both operations use the same `_tmp` and `_bak` names.

No live corruption was observed, and Android's default `AsyncTask` executor is serial for ordinary async tasks, but it does not serialize those tasks against the direct synchronous `saveDictionaryNow()` path. A narrow synchronized save method would match the important part of current Gboard's behavior without replacing the scheduler.

## Failure matrix

| State at process death/load | Current Compatibility behavior | Assessment |
|---|---|---|
| main only | load main | correct |
| main + backup | load main; retain backup | correct |
| main + temporary | load main; stale temporary removed on next save | safe, newest unfinished save may be lost |
| backup + temporary, no main | restore backup first | conservative and correct for known-good-first policy |
| backup only, no main | restore backup | correct |
| temporary only, no main | restore temporary | correct |
| corrupt main + valid backup | archive main, restore backup, retry | correct |
| corrupt main + corrupt backup + valid temporary | backup retry fails; temporary is currently ignored | incomplete fallback |
| missing main + corrupt backup + valid temporary | backup is moved to main, then fails; temporary is currently ignored | incomplete fallback |
| simultaneous scheduled and forced saves | both can rotate the same three paths | avoidable race |
| intentional dictionary deletion while `_bak` remains | only main is deleted | stale data can be resurrected later |
| explicit clear followed by successful empty persist | previous non-empty main remains as `_bak` | stale private data remains recoverable |

## Findings

### 1. `_tmp` is not used as a second recovery candidate after a failed backup

`prepareForLoad()` can restore `_tmp` only when restoring `_bak` was impossible. Once `_bak` has been renamed to main, a subsequent native enrollment failure reaches `recoverAfterLoadFailure()`, which looks only for another `_bak`. A valid `_tmp` is ignored and the engine can fall back to empty.

Recommended narrow correction: make post-load recovery try `_bak` first and `_tmp` second. Native enrollment remains the validator, so a partial temporary file will fail safely. The retry count remains naturally bounded because each candidate is consumed at most once.

### 2. Retained backups change intentional deletion semantics

The original factory deletion path deletes only the main file because the original persistence path did not retain `_bak`. After Compatibility v20, disabling a mutable dictionary can leave `_bak`; re-enabling it can cause `prepareForLoad()` to restore deliberately deleted data.

The explicit user-dictionary clear task also persists an empty main while retaining the old non-empty main as `_bak`. This is undesirable for a user-visible destructive action and differs from current Gboard's zero-size handling.

Recommended narrow correction: after an intentional main-file deletion or a successfully persisted explicit clear, delete `_bak`, `_tmp`, and stale `_unreadable` sidecars for that dictionary. Ordinary learning, editing, importing, and scheduled saves should continue retaining rolling backups.

### 3. Scheduled and forced saves are not serialized with each other

Recommended narrow correction: guard `SaveDictionaryTask.saveDictionaries()` with one static shared lock. An instance-synchronized method would be insufficient because scheduled and forced saves create different task instances. The shared lock preserves the old scheduler, interval, compaction thresholds, notification behavior, and call sites while preventing concurrent rotation of the same filenames. It mirrors current Gboard's class-monitor serialization without backporting its future/executor architecture.

## Non-goals

This audit does not propose changing:

- the native Trie format;
- the 500,000-entry user-dictionary capacity;
- the 90% compaction target;
- import/export file formats;
- contact dictionary generation;
- sync behavior;
- dictionary learning weights;
- current healthy user data.

## Proposed validation

Any implementation should be tested in an isolated application ID with copied test dictionaries, never by fault-injecting the validated compatibility package. The minimum cases are:

1. main missing, valid backup;
2. main missing, corrupt backup, valid temporary;
3. corrupt main, corrupt backup, valid temporary;
4. corrupt main, valid backup;
5. explicit clear removes all recoverable old copies;
6. disable/re-enable does not resurrect a deleted mutable dictionary;
7. overlapping scheduled/forced save requests leave a valid main and backup.
