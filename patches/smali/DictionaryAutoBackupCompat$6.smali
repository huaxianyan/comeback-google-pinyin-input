.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->toast(Landroid/content/Context;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$c:Landroid/content/Context;

.field final synthetic val$text:Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 278
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$c:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$text:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 279
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$c:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$text:Ljava/lang/String;

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 280
    return-void
.end method
