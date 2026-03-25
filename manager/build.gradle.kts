plugins {
    alias(libs.plugins.agp.app) apply false
    alias(libs.plugins.kotlin) apply false
    alias(libs.plugins.compose.compiler) apply false
}

val androidMinSdkVersion by extra(31)
val androidTargetSdkVersion by extra(36)
val androidCompileSdkVersion by extra(36)
val androidBuildToolsVersion by extra("36.1.0")
val androidCompileNdkVersion: String by extra(libs.versions.ndk.get())
val androidSourceCompatibility by extra(JavaVersion.VERSION_21)
val androidTargetCompatibility by extra(JavaVersion.VERSION_21)
val managerVersionCode by extra(getVersionCode())
val managerVersionName by extra(getVersionName())

fun getGitCommitCount(): Int {
    return try {
        val process = Runtime.getRuntime().exec(arrayOf("git", "rev-list", "--count", "HEAD"))
        process.inputStream.bufferedReader().use { it.readText().trim().toInt() }
    } catch (e: Exception) {
        2393
    }
}

fun getGitDescribe(): String {
    return try {
        val process = Runtime.getRuntime().exec(arrayOf("git", "describe", "--tags", "--always"))
        val result = process.inputStream.bufferedReader().use { it.readText().trim() }
        if (result.isEmpty()) "v32393" else result
    } catch (e: Exception) {
        "v32393"
    }
}

fun getVersionCode(): Int {
    return 32393
}

fun getVersionName(): String {
    return try {
        val desc = getGitDescribe()
        if (desc.isEmpty()) "v32393" else desc
    } catch (e: Exception) {
        "v32393"
    }
}
