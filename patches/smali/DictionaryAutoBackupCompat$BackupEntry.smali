.class final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "BackupEntry"
.end annotation


# instance fields
.field final name:Ljava/lang/String;

.field final uri:Landroid/net/Uri;


# direct methods
.method constructor <init>(Ljava/lang/String;Landroid/net/Uri;)V
    .registers 3

    .line 217
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->uri:Landroid/net/Uri;

    return-void
.end method
