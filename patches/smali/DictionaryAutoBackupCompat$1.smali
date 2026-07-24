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


# direct methods
.method constructor <init>(Landroid/content/Context;Z)V
    .registers 3

    .line 98
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$context:Landroid/content/Context;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$force:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 98
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$context:Landroid/content/Context;

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;->val$force:Z

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->createAndExport(Landroid/content/Context;Z)V
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$000(Landroid/content/Context;Z)V

    return-void
.end method
