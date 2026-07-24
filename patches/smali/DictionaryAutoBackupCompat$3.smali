.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->rotate(Landroid/content/Context;I)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 223
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public compare(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)I
    .registers 3

    .line 224
    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result p1

    return p1
.end method

.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .registers 3

    .line 223
    check-cast p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    check-cast p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    invoke-virtual {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;->compare(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)I

    move-result p1

    return p1
.end method
