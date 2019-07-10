#ifndef CUSTOMTABLEMODEL_H
#define CUSTOMTABLEMODEL_H

#include <QObject>
#include <QAbstractTableModel>

class CustomTableModel : public QAbstractTableModel
{
    Q_OBJECT
    Q_PROPERTY(int rows READ getRows WRITE setRows NOTIFY rowsChanged)
    Q_PROPERTY(int columns READ getColumns WRITE setColumns NOTIFY columnsChanged)
public:
    CustomTableModel(int rows = 0,int columns = 0);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    int getRows() const;
    void setRows(const int rows) ;

    int getColumns() const;
    void setColumns(const int rows) ;

signals:
    void rowsChanged(int oldValue,int newValue);
    void columnsChanged(int oldValue,int newValue);

private:
    int mRows;
    int mColumns;
};

#endif // CUSTOMTABLEMODEL_H
