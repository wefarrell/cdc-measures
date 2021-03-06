(function(){
    let measureLabels = null;
    if(window.location.href.indexOf("measure_correlations") > -1) {
        $.get('/measure_correlations.json', buildChart)
    }

    function formatData(serverResponse){
        let measureIndexes = {}
        function toIndex(measure){
            if(measureIndexes[measure] == undefined){
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

        return {
            data: data,
            measures: measureList
        }
    }

    $(document).on('measures_loaded', (e, labels) => {
        measureLabels = labels
    });

    function buildChart(results) {
        const params = formatData(results);
        const categories = params.measures.map( (measure) => measureLabels[measure] )

        Highcharts.chart('chart-container', {
            chart: {
                type: 'heatmap',
                marginTop: 40,
                marginBottom: 80,
                plotBorderWidth: 1,
                height: 768,
                width: 1024
            },

            title: {
                text: 'Measure Correlations'
            },

            xAxis: {
                categories: categories
            },

            yAxis: {
                categories: categories,
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
                    return '<b>' + this.series.xAxis.categories[this.point.x] + '</b> correlates <br><b>' +
                        this.point.value.toFixed(2) + '</b> to <br><b>' + this.series.yAxis.categories[this.point.y] + '</b>';
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
})();