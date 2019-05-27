/****************************************************************************
** Meta object code from reading C++ file 'stats.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../V-GA-lize/models/stats.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'stats.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Stats_t {
    QByteArrayData data[15];
    char stringdata0[113];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Stats_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Stats_t qt_meta_stringdata_Stats = {
    {
QT_MOC_LITERAL(0, 0, 5), // "Stats"
QT_MOC_LITERAL(1, 6, 14), // "averageChanged"
QT_MOC_LITERAL(2, 21, 0), // ""
QT_MOC_LITERAL(3, 22, 10), // "minChanged"
QT_MOC_LITERAL(4, 33, 10), // "maxChanged"
QT_MOC_LITERAL(5, 44, 13), // "stddevChanged"
QT_MOC_LITERAL(6, 58, 7), // "average"
QT_MOC_LITERAL(7, 66, 3), // "min"
QT_MOC_LITERAL(8, 70, 3), // "max"
QT_MOC_LITERAL(9, 74, 6), // "stddev"
QT_MOC_LITERAL(10, 81, 8), // "Property"
QT_MOC_LITERAL(11, 90, 7), // "AVERAGE"
QT_MOC_LITERAL(12, 98, 3), // "MIN"
QT_MOC_LITERAL(13, 102, 3), // "MAX"
QT_MOC_LITERAL(14, 106, 6) // "STDDEV"

    },
    "Stats\0averageChanged\0\0minChanged\0"
    "maxChanged\0stddevChanged\0average\0min\0"
    "max\0stddev\0Property\0AVERAGE\0MIN\0MAX\0"
    "STDDEV"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Stats[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       4,   46, // properties
       1,   62, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   34,    2, 0x06 /* Public */,
       3,    1,   37,    2, 0x06 /* Public */,
       4,    1,   40,    2, 0x06 /* Public */,
       5,    1,   43,    2, 0x06 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::Float,    2,
    QMetaType::Void, QMetaType::Float,    2,
    QMetaType::Void, QMetaType::Float,    2,
    QMetaType::Void, QMetaType::Float,    2,

 // properties: name, type, flags
       6, QMetaType::Float, 0x00495103,
       7, QMetaType::Float, 0x00495103,
       8, QMetaType::Float, 0x00495103,
       9, QMetaType::Float, 0x00495103,

 // properties: notify_signal_id
       0,
       1,
       2,
       3,

 // enums: name, alias, flags, count, data
      10,   10, 0x0,    4,   67,

 // enum data: key, value
      11, uint(Stats::AVERAGE),
      12, uint(Stats::MIN),
      13, uint(Stats::MAX),
      14, uint(Stats::STDDEV),

       0        // eod
};

void Stats::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Stats *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->averageChanged((*reinterpret_cast< float(*)>(_a[1]))); break;
        case 1: _t->minChanged((*reinterpret_cast< float(*)>(_a[1]))); break;
        case 2: _t->maxChanged((*reinterpret_cast< float(*)>(_a[1]))); break;
        case 3: _t->stddevChanged((*reinterpret_cast< float(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (Stats::*)(float );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Stats::averageChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (Stats::*)(float );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Stats::minChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (Stats::*)(float );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Stats::maxChanged)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (Stats::*)(float );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Stats::stddevChanged)) {
                *result = 3;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<Stats *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< float*>(_v) = _t->average(); break;
        case 1: *reinterpret_cast< float*>(_v) = _t->min(); break;
        case 2: *reinterpret_cast< float*>(_v) = _t->max(); break;
        case 3: *reinterpret_cast< float*>(_v) = _t->stddev(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<Stats *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setAverage(*reinterpret_cast< float*>(_v)); break;
        case 1: _t->setMin(*reinterpret_cast< float*>(_v)); break;
        case 2: _t->setMax(*reinterpret_cast< float*>(_v)); break;
        case 3: _t->setStddev(*reinterpret_cast< float*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject Stats::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_Stats.data,
    qt_meta_data_Stats,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Stats::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Stats::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Stats.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Stats::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 4;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 4;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void Stats::averageChanged(float _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void Stats::minChanged(float _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void Stats::maxChanged(float _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void Stats::stddevChanged(float _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
