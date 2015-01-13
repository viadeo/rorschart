/*jslint browser: true, indent: 2, plusplus: true, vars: true */
/*global google, $*/

(function () {
  'use strict';

  var Rorschart, resize, refresh;

  if (window.hasOwnProperty('google')) {
    google.load('visualization', '1.0', {'packages': ['corechart', 'table']});
  } else {
    throw new Error("Please include Google Charts first.");
  }

  function setText(element, text) {
    if (document.body.innerText) {
      element.innerText = text;
    } else {
      element.textContent = text;
    }
  }

  function chartError(element, message) {
    setText(element, "Error Loading Chart: " + message);
    element.style.color = "#ff0000";
  }

  function getElement(element) {
    if (typeof element === "string") {
      element = document.getElementById(element);
    }
    return element;
  }

  resize = function (callback) {
    if (window.attachEvent) {
      window.attachEvent("onresize", callback);
    } else if (window.addEventListener) {
      window.addEventListener("resize", callback, true);
    }
    callback();
  };

  function processDate(dataTable) {
    var i, j, col, date_ISO8601;

    for (i = 0; i < dataTable.cols.length; i++) {
      col = dataTable.cols[i];
      if ((col.type === 'date') || (col.type === 'datetime')) {
        for (j = 0; j < dataTable.rows.length; j++) {
          date_ISO8601 = dataTable.rows[j].c[i].v;
          dataTable.rows[j].c[i].v = new Date(date_ISO8601);
        }
      }
    }
    return dataTable;
  }

  function drawChart(chart, chartClass, element, dataSource, options) {

    var dataTable, type, wrapper, columns = [0],  columnsMap = {};

    type = Object.prototype.toString.call(dataSource);
    if (type === '[object String]') {
      dataSource = JSON.parse(dataSource);
    }

    console.log('dataSource toString:',dataSource);

    dataSource = Object.create(dataSource);
    if (dataSource.cols == null) {
      setText(element, "Empty data")
      return
    }

    console.log('datasource.length',dataSource.cols.length);
    for (var i = 0; i < dataSource.cols.length; i++) {
      console.log('dataSource.cols['+i+']',dataSource.cols[i]);
      // var col = seriesMap[i].column;
      // columnsMap[col] = i;
      columns.push(dataSource.cols[i]);
    }

    console.log('Object dataSource:',dataSource);

    try {
      dataTable = new google.visualization.DataTable(processDate(dataSource));
    } catch (err) {
      chartError(element, err.message);
      throw err;
    }

    chart.chart = new chartClass(element);


    function showHideSeries () {
        var sel = chart.chart.getSelection();
        console.log('selectedItem:',sel);
        // if selection length is 0, we deselected an element
        console.log('selected ? ',sel.length);
        if (sel.length > 0) {

            // if row is undefined, we clicked on the legend
            console.log('sel[0].row',sel[0].row);
            if (sel[0].row == null) {
                console.log('sel[0].column:',sel[0].column);
                var col = sel[0].column;
                if (typeof(columns[col]) == 'number') {
                    var src = columns[col];

                    // hide the data series
                    columns[col] = {
                        label: data.getColumnLabel(src),
                        type: data.getColumnType(src),
                        sourceColumn: src,
                        calc: function () {
                            return null;
                        }
                    };

                    // grey out the legend entry
                    //dataSource[columnsMap[src]].color = '#CCCCCC';
                }
                else {
                    //var src = columns[col].sourceColumn;

                    // show the data series
                    columns[col] = src;
                    //dataSource[columnsMap[src]].color = null;
                }
                var view = new google.visualization.DataView(dataTable) || {};
                view.columns = columns;
                chart.chart.setView(view);
                chart.chart.draw();
            }
        }
    }

   wrapper = new google.visualization.ChartWrapper({
        chartType: 'ColumnChart',
        dataTable: dataTable,
        options: options,
        containerId: element
      });


    google.visualization.events.addListener(wrapper, 'select', showHideSeries);

    var view = {
        columns: columns
    };

    console.log('chartClass',chartClass);
    resize(function () {
      //chart.chart.draw(dataTable, options);

      // let's use the wrapper now
      wrapper.draw();
      var view_ = new google.visualization.DataView(dataTable)
      console.log('view:',view_);
      wrapper.setView(view_);
      wrapper.draw();
    });
  }

  function retrieveRemoteData(element, url, callback) {
    $.ajax({
      url: url,
      statusCode: {
        202: function (data) {
          //Use traditionnal polling here instead of long one. Heroku in mind.
          setTimeout(function () {
            retrieveRemoteData(element, url, callback);
          }, 1500);
        },
        200: function (data) {
          callback(data);
        }
      },
      error: function (jqXHR, textStatus, errorThrown) {
        var message = (typeof errorThrown === "string") ? errorThrown : errorThrown.message;
        chartError(element, message + " "+ jqXHR.responseText);
      }
    });
  }

  refresh = function (chart, klass_name, hideRefreshMessage) {

    if (!hideRefreshMessage) {
      setText(chart.element, 'Loading Chart data...');
    }

    chart.chartClass = klass_name || chart.chartClass
    if (typeof chart.dataSource === "string") {
      retrieveRemoteData(chart.element, chart.dataSource, function (data) {
        google.setOnLoadCallback(drawChart(chart, chart.chartClass, chart.element, data, chart.options));
      });
    } else {
      google.setOnLoadCallback(drawChart(chart, chart.chartClass, chart.element, chart.dataSource, chart.options));
    }
  }

  function setElement(chart, chartClass, element, dataSource, options) {
    
    if (typeof element === "string") {
      element = document.getElementById(element);
    }

    chart.chartClass = chartClass
    chart.element = element;
    chart.options = options || {};
    chart.dataSource = dataSource;
    Rorschart.charts[element.id] = chart;
    refresh(chart);
  }

  Rorschart = {
    GoogleChart: function (chartClass, element, dataSource, options) {
      setElement(this, chartClass, element, dataSource, options);
    },
    charts: {}
  };


  window.Rorschart = Rorschart;
  window.Rorschart.refresh = refresh;

}());
