# Prevent ML Kit text recognition classes from being removed
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**
