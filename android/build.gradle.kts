allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

buildscript {
    extra.apply {
        set("kotlin_version", "1.9.22")
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Set Kotlin version for all subprojects
extra.set("kotlin_version", "1.9.22")

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
