.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->createAndExport(Landroid/content/Context;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$force:Z

.field final synthetic val$name:Ljava/lang/String;

.field final synthetic val$output:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 5

    .line 115
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$output:Landroid/net/Uri;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$name:Ljava/lang/String;

    iput-boolean p4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$force:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    .line 116
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$output:Landroid/net/Uri;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$name:Ljava/lang/String;

    iget-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;->val$force:Z

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V
    invoke-static {v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$100(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V

    .line 117
    return-void
.end method
