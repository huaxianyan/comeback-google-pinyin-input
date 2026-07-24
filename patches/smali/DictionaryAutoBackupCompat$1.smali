.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$force:Z

.field final synthetic val$tree:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/net/Uri;Z)V
    .registers 4

    .line 142
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$tree:Landroid/net/Uri;

    iput-boolean p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$force:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 144
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$tree:Landroid/net/Uri;

    iget-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$force:Z

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V
    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$000(Landroid/content/Context;Landroid/net/Uri;Z)V

    .line 145
    return-void
.end method
