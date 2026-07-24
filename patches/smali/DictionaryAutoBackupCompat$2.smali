.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$created:Landroid/net/Uri;

.field final synthetic val$force:Z

.field final synthetic val$outputName:Ljava/lang/String;

.field final synthetic val$tree:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 6

    .line 172
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$tree:Landroid/net/Uri;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$created:Landroid/net/Uri;

    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$outputName:Ljava/lang/String;

    iput-boolean p5, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$force:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    .line 174
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$tree:Landroid/net/Uri;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$created:Landroid/net/Uri;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$outputName:Ljava/lang/String;

    iget-boolean v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$force:Z

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    invoke-static {v0, v1, v2, v3, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$100(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    .line 175
    return-void
.end method
