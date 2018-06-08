#include "directory.h"
#include "filesystemtreemodel.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // 加载语言文件
    QTranslator translator;
    bool b = false;
    b = translator.load(":/htfm_zh.qm");
    if (b)
        app.installTranslator(&translator);

    QQmlApplicationEngine engine;

    //
    qmlRegisterType<Directory>("directory", 1, 0, "Directory");

    // 加载model
    QFileSystemModel *fsm = new FileSystemTreeModel(&engine);
    fsm->setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
    fsm->setRootPath(QDir::rootPath());
//    fsm->setRootPath(QDir::homePath());
    fsm->setResolveSymlinks(false);
    engine.rootContext()->setContextProperty("fileSystemTreeModel", fsm);
//    engine.rootContext()->setContextProperty("rootPathIndex", fsm->index(fsm->rootPath()));

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;


    return app.exec();
}
