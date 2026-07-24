.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->rotate(Landroid/content/Context;Landroid/net/Uri;I)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 315
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public compare(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;)I
    .registers 3

    .line 317
    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;->name:Ljava/lang/String;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;->name:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result p1

    return p1
.end method

.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .registers 3

    .line 315
    check-cast p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;

    check-cast p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;

    invoke-virtual {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;->compare(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;)I

    move-result p1

    return p1
.end method
