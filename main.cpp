#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include "./models/vgalize.h"

int main(int argc, char *argv[])
{
    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QObject::connect((QObject*)&engine, SIGNAL(quit()), &app, SLOT(quit()));

    GAViz gaviz; //(&engine);
    qmlRegisterType<Individual>("gaviz", 1, 0, "IndividualProperty");
    qmlRegisterType<Stats>("gaviz", 1, 0, "StatsProperty");

    //qmlRegisterType<Stats>("gaviz", 1, 0, "Stats");

//    qmlRegisterUncreatableMetaObject(
//      GAVizErrors::staticMetaObject, // static meta object
//      "gavizerrors",                // import statement (can be any string)
//       1, 0,                        // major and minor version of the import
//      "GAVizError",                 // name in QML (does not have to match C++ name)
//      "Error: only enums"            // error in case someone tries to create a MyNamespace object
//    );

//    qmlRegisterUncreatableMetaObject(
//      GAVizErrors::staticMetaObject, // static meta object
//      "gavizstats",                // import statement (can be any string)
//       1, 0,                        // major and minor version of the import
//      "GAVizStats",                 // name in QML (does not have to match C++ name)
//      "Error: only enums"            // error in case someone tries to create a MyNamespace object
//    );



    engine.rootContext()->setContextProperty("gaviz", &gaviz);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
