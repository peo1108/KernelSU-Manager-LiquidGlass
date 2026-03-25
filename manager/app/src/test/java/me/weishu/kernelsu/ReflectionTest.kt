package me.weishu.kernelsu

import org.junit.Test
import top.yukonga.miuix.kmp.theme.ColorScheme

class ReflectionTest {
    @Test
    fun printColorScheme() {
        println("=== COLORSCHEME METHODS ===")
        ColorScheme::class.java.declaredMethods.forEach { println(it.name) }
        println("===========================")
    }
}
