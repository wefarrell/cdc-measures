$.get('/measure_correlations.json', buildChart)

function formatData(serverResponse){
    let measureIndexes = {}
    function toIndex(measure){
        if(measureIndexes[measure] == undefined){
            console.log(measure, Object.keys(measureIndexes).length)
            measureIndexes[measure] = Object.keys(measureIndexes).length
        }
        return measureIndexes[measure]
    }

    const data = serverResponse.map( (correlation) => {
        const measure1Index = toIndex(correlation.measure_1)
        const measure2Index = toIndex(correlation.measure_2)
        return [measure1Index, measure2Index, correlation.correlation];
    });
    const measureList = Object.values(_.invert(measureIndexes))

    console.log(_.invert(measureIndexes)['0']);
    return {
        data: data,
        measures: measureList
    }
}

function buildChart(results) {
    const params = formatData(results)



    Highcharts.chart('chart-container', {
        chart: {
            type: 'heatmap',
            marginTop: 40,
            marginBottom: 80,
            plotBorderWidth: 1,
            height: 1000,
            width: 1600
        },

        title: {
            text: 'Measure Correlations'
        },

        xAxis: {
            categories: params.measures
        },

        yAxis: {
            categories: params.measures,
            title: null
        },
        plotOptions: {
            series: {
                dataLabels: {
                    enabled: true,
                    formatter: function(){ return this.point.value.toFixed(1)}
                }
            }
        },
        colorAxis: {
            min: 0,
            minColor: '#FFFFFF',
            maxColor: Highcharts.getOptions().colors[0]
        },

        legend: {
            align: 'right',
            layout: 'vertical',
            margin: 0,
            verticalAlign: 'top',
            y: 25,
            symbolHeight: 280
        },

        tooltip: {
            formatter: function () {
                return '<b>' + this.series.xAxis.categories[this.point.x] + '</b> sold <br><b>' +
                    this.point.value.toFixed(2) + '</b> items on <br><b>' + this.series.yAxis.categories[this.point.y] + '</b>';
            }
        },

        series: [{
            name: 'Sales per employee',
            borderWidth: 1,
            data: params.data,
            dataLabels: {
                enabled: true,
                color: '#000000'
            }
        }]

    });
}