/****************************************************************************
** Meta object code from reading C++ file 'individual.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../V-GA-lize/models/individual.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'individual.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Individual_t {
    QByteArrayData data[10];
    char stringdata0[88];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Individual_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Individual_t qt_meta_stringdata_Individual = {
    {
QT_MOC_LITERAL(0, 0, 10), // "Individual"
QT_MOC_LITERAL(1, 11, 8), // "Property"
QT_MOC_LITERAL(2, 20, 10), // "Generation"
QT_MOC_LITERAL(3, 31, 7), // "Cluster"
QT_MOC_LITERAL(4, 39, 7), // "Parent1"
QT_MOC_LITERAL(5, 47, 7), // "Parent2"
QT_MOC_LITERAL(6, 55, 7), // "Fitness"
QT_MOC_LITERAL(7, 63, 4), // "Rank"
QT_MOC_LITERAL(8, 68, 8), // "NumGenes"
QT_MOC_LITERAL(9, 77, 10) // "Chromosome"

    },
    "Individual\0Property\0Generation\0Cluster\0"
    "Parent1\0Parent2\0Fitness\0Rank\0NumGenes\0"
    "Chromosome"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Individual[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       1,   14, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // enums: name, alias, flags, count, data
       1,    1, 0x0,    8,   19,

 // enum data: key, value
       2, uint(Individual::Generation),
       3, uint(Individual::Cluster),
       4, uint(Individual::Parent1),
       5, uint(Individual::Parent2),
       6, uint(Individual::Fitness),
       7, uint(Individual::Rank),
       8, uint(Individual::NumGenes),
       9, uint(Individual::Chromosome),

       0        // eod
};

void Individual::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

QT_INIT_METAOBJECT const QMetaObject Individual::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_Individual.data,
    qt_meta_data_Individual,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Individual::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Individual::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Individual.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Individual::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
