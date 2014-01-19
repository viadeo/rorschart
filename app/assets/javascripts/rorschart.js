/*jslint browser: true, indent: 2, plusplus: true, vars: true */
/*global google, $*/

(function () {
  'use strict';

  var rorschart, resize;

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

  function drawChart(ChartClass, element, dataSource, options) {

    var dataTable, type;

    type = Object.prototype.toString.call(dataSource);
    if (type === '[object String]') {
      dataSource = JSON.parse(dataSource);
    }

    dataSource = Object.create(dataSource);

    try {
      dataTable = new google.visualization.DataTable(processDate(dataSource));
    } catch (err) {
      chartError(element, err.message);
      throw err;
    }

    var chart = new ChartClass(element);

    resize(function () {
      chart.draw(dataTable, options);
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
        chartError(element, message + jqXHR.responseText);
      }
    });
  }



  rorschart = function (chartClass, element, dataSource, options) {
    element = getElement(element);
    if (typeof dataSource === "string") {
      retrieveRemoteData(element, dataSource, function (data) {
        google.setOnLoadCallback(drawChart(chartClass, element, data, options));
      });
    } else {
      google.setOnLoadCallback(drawChart(chartClass, element, dataSource, options));
    }
  };

  window.Rorschart = rorschart;

}());
