(function(){
    $.getJSON('measure_labels.json', function (labels) {
        const labelMap = Object.assign({}, ...labels.map(measure => ({[measure.value]: measure.label})))
        $(document).trigger('measures_loaded', [labelMap])
    })
})();