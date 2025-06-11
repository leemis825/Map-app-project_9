// ✅ 전 프로젝트에서 사용하는 공통 저장소 설정
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ 빌드 디렉토리 위치를 프로젝트 외부로 지정 (빌드 파일 분리 관리 목적)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// ✅ (선택) 앱 모듈 우선 평가 - 단일 모듈이면 없어도 되지만 무해
subprojects {
    this.evaluationDependsOn(":app")
}

// ✅ 'clean' 명령 시 전체 빌드 디렉토리 제거
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ✅ Java 관련 컴파일러 경고 제거 (-source 8, -target 8 obsolete warning 제거)
tasks.withType<JavaCompile> {
    options.compilerArgs.add("-Xlint:-options")
}
