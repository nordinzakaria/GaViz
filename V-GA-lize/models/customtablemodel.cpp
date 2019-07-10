#include "customtablemodel.h"

CustomTableModel::CustomTableModel(int rows, int columns)
    : mRows(rows),mColumns(columns)
{

}

int CustomTableModel::getRows() const{
    return mRows;
}

void CustomTableModel::setRows(const int rows) {
    int oldValue = mRows;
    mRows = rows;

    emit columnsChanged(oldValue,rows);
}

int CustomTableModel::getColumns() const{
    return mColumns;
}

void CustomTableModel::setColumns(const int columns) {
    int oldValue = mColumns;
    mColumns = columns;

    emit columnsChanged(oldValue,columns);
}


int CustomTableModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()){
        return 0;
    }else{
        return mRows;
    }
}
int CustomTableModel::columnCount(const QModelIndex &parent) const {
    if (parent.isValid()){
        return 0;
    }else{
        return mColumns;
    }
}

QVariant CustomTableModel::data(const QModelIndex &index, int role) const {
    return QVariant();
}

Qt::ItemFlags CustomTableModel::flags(const QModelIndex &index) const {
    return Qt::NoItemFlags;
}

