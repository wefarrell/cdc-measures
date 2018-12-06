function initMap (){
    const dataUrls = {
        censusTracts: 'https://data.cityofnewyork.us/api/geospatial/fxpq-c8ku?method=export&format=GeoJSON',
        measures: '/city_measures.json',
        mapTypeId: 'coordinate'
    };
    const map = new google.maps.Map(document.getElementById('map'), {
        zoom: 13,
        center: {lat: 40.7128, lng: -74.0060},
    });
    const $selectMeasure = $('#select_measure')

    const shapeProps = {
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: .3,
        fillColor: 'red',
        fillOpacity: 0,
        map: map
    };

    const infoWindow = new google.maps.InfoWindow;
    const loadShapes = new Promise((resolve, reject) => {
        $.getJSON(dataUrls.censusTracts, (result) => {
            const censusTracts = result.features.map((tract) => {
                const coords = _.flatten(tract.geometry.coordinates[0]).map((coords) => {
                    return {lng: coords[0], lat: coords[1]}
                });
                const shape = new google.maps.Polygon(_.extend(shapeProps, {paths: coords}));
                return {
                    shape: shape,
                    id: tract.properties.ct2010
                };
            });
            resolve(censusTracts)
        });
    });

    const loadMeasures = new Promise((resolve, reject) => {
        $.getJSON(dataUrls.measures, (data) => {
            const indexedTracts = Object.assign({}, ...data.map(tract => {
                const id = tract.unique_id.substr(tract.unique_id.length - 6)
                return {[id]: tract}
            }));
            resolve(indexedTracts)
        })
    });

    const loadMeasureLabels = new Promise((resolve, reject) => {
        $(document).on('measures_loaded', (e, measures) => {
            const options = _.map(measures, (label, value) => `<option value="${value}">${label}</option>`)
            $selectMeasure.append(options)
            resolve(measures)
        });
    });

    const renderShape = (shape, measures, formatMeasure) => {
        if(!measures) {
            return;
        }
        const currentMeasure = $selectMeasure.val();
        const value = measures[currentMeasure];
        const openPopup = (event) => {
            let content = `<b>${formatMeasure(value, currentMeasure)}</b><br/>`;
            content += _(measures).omit('unique_id', 'geo_location', currentMeasure)
                .map(formatMeasure).join('<br/>');
            infoWindow.setContent(content);
            infoWindow.setPosition(event.latLng);
            infoWindow.open(map);
        };
        shape.setOptions({fillOpacity: value / 100.0 });
        google.maps.event.clearListeners(shape, 'click');
        shape.addListener('click', openPopup);
    };

    Promise.all([loadShapes, loadMeasures, loadMeasureLabels]).then((results) => {
        const [tractShapes, tractMeasures, measureLabels] = results;
        const formatMeasure = (value, measure) => `${measureLabels[measure]}: ${value}%`
        const renderTracts = () => {
            infoWindow.close()
            tractShapes.map((tractShape) => {
                const measures = tractMeasures[tractShape.id];
                const shape = tractShape.shape;
                renderShape(shape, measures, formatMeasure)
            });
        };
        $selectMeasure.change(renderTracts);
        renderTracts()
    });

};
