#!/bin/bash

echo "🚀 开始构建曹操数字人APK..."

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "❌ 未找到Java环境"
    echo "📥 正在安装Java..."
    
    # 检查系统类型
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install openjdk@8
            export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
        else
            echo "请先安装Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
    else
        # Linux
        sudo apt-get update
        sudo apt-get install -y openjdk-8-jdk
        export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    fi
fi

# 设置Android SDK路径（如果存在）
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi

echo "☕ Java版本："
java -version

echo "🔧 开始Gradle构建..."
chmod +x gradlew

# 尝试构建APK
if ./gradlew assembleDebug --stacktrace; then
    echo "✅ APK构建成功！"
    echo "📁 APK位置：app/build/outputs/apk/debug/app-debug.apk"
    
    # 复制APK到当前目录
    cp app/build/outputs/apk/debug/app-debug.apk ./caocao-digital-human.apk
    echo "📱 APK已复制到：./caocao-digital-human.apk"
    
    echo ""
    echo "🎉 构建完成！"
    echo "📱 安装方法："
    echo "   1. 将caocao-digital-human.apk传输到Android设备"
    echo "   2. 在设备上允许未知来源安装"
    echo "   3. 点击APK文件安装"
    echo "   4. 打开'曹操数字人'应用"
    
else
    echo "❌ APK构建失败"
    echo "💡 可能的解决方案："
    echo "   1. 检查Java和Android SDK是否正确安装"
    echo "   2. 运行: export ANDROID_HOME=/path/to/android/sdk"
    echo "   3. 查看上面的错误日志"
    echo ""
    echo "🔄 替代方案："
    echo "   使用Termux在Android设备上直接运行Web版本"
fi
