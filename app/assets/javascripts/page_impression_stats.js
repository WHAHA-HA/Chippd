//= require underscore

// PageImpressionStats provides an interface to get
// statistics about Page Impressions.
//
// <--- Usage ---> 
//
// Page stats:
// 
// var pageStats = PageImpressionStats.forPage(pageId);
// pageStats.total.dataUsed(callbackFn); // 8.59 MB
// pageStats.total.impressions(callbackFn); // 50
// pageStats.total.mostPopular(callbackFn); // [{section_id: '', section_type: '', impressions: 50}]
// pageStats.total.leastPopular(callbackFn);  // [{section_id: '', section_type: '', impressions: 50}]
//
// Section Stats:
// 
// var pageSectionStats = PageImpressionStats.forPageSection(pageId, sectionId);
// pageSectionStats.total.impressions(callbackFn); // number
// pageSectionStats.day.impressions(callbackFn);
// pageSectionStats.week.impressions(callbackFn);
// pageSectionStats.month.impressions(callbackFn);
// 
// pageSectionStats.day.growth(callbackFn); // number
// pageSectionStats.week.growth(callbackFn);
// pageSectionStats.month.growth(callbackFn);

(function(window) {
  var eventCollection = 'impressions';
  
  var PageImpressionStats = {    
    forPage: function(pageId) {
      var pageStats = {};
      
      // creates stat functions for each of the timeframes
      // Eg., total.dataUsed(fn), total.impressions(fn), total.mostPopular(fn), total.leastPopular(fn)
      // creates these functions for total, day, week, month
      _.each(['total', 'day', 'week', 'month'], function(timeframe) {        
        pageStats[timeframe] = {};
        
        var statFns = {
          dataUsed: dataUsed,
          impressions: impressionCount,
          mostPopular: mostPopular,
          leastPopular: leastPopular
        };
        
        _.each(statFns, function(statFn, statName) {
          pageStats[timeframe][statName] = function(callback) {
            var options = {
              pageId: pageId,
              callback: callback
            };
            
            if(timeframe != 'total') {
              options['timeframe'] = 'previous_' + timeframe;
            }
          
            statFn(options);
          };
        });
      });
      
      return pageStats;
    },
    
    forPageSection: function(pageId, sectionId) {
      var sectionStats = {};
      
      // creates stat functions for each of the timeframes
      // Eg., total.impressions(fn), day.impressions(fn), week.impressions(fn), month.impressions(fn),
      // day.growth(fn), week.growth(fn), month.growth(fn)
      _.each(['total', 'day', 'week', 'month'], function(timeframe) {        
        sectionStats[timeframe] = {};
        
        var statFns = {
          impressions: impressionCount,
          growth: sectionGrowth
        };
        
        _.each(statFns, function(statFn, statName) {
          if(timeframe == 'total' && statName == 'growth') return;
          
          sectionStats[timeframe][statName] = function(callback) {
            var options = {
              pageId: pageId,
              sectionId: sectionId,
              callback: callback
            };
            
            if(timeframe != 'total') {
              options['timeframe'] = 'previous_' + timeframe;
            }
          
            statFn(options);
          };
        });
      });
      
      return sectionStats;
    }
  };
  
  function dataUsed(options)
  {
    Keen.onChartsReady(function() {
      var metric = new Keen.Metric('storage_used', {
        analysisType: "extraction",
        targetProperty: 'storage_used',
        filters: [{
          property_name: "page_id",
          operator: "eq",
          property_value: options.pageId
        }]
      });
      
      if(options.timeframe) {
        metric.timeframe(options.timeframe);
      }

      metric.getResponse(function(response){
        if(!options.callback) return;
        
        var results = response.result;
        var storage_used = 0;
        
        if(results.length > 0) {
          storage_used = _.last(results).storage_used;
        }
        
        options.callback(storage_used);
      });
    });
  };
  
  // options = { pageId: '', timeframe: '', callback: function() }
  function impressionCount(options) 
  {
    Keen.onChartsReady(function() {
      var metric = new Keen.Metric(eventCollection, {
        analysisType: "count",
        filters: [{
          property_name: "page_id",
          operator: "eq",
          property_value: options.pageId
        }]
      });
      
      if(options.sectionId) {
        metric.addFilter("section_id", "eq", options.sectionId);
      }
      
      if(options.timeframe) {
        metric.timeframe(options.timeframe);
      }

      metric.getResponse(function(response){
        if(!options.callback) return;
        options.callback(response.result);
      });
    });
  };
  
  function sectionGrowth(options) 
  {
    if(!options.callback) return;
    
    async.parallel([
      // get total section impressions
      function(parallelCallback) {
        var totalOptions = {
          pageId: options.pageId,
          sectionId: options.sectionId,
          callback: function(impressions) {
            parallelCallback(null, impressions);
          }
        };
        impressionCount(totalOptions);
      }, 
      // get section impressions for timeframe
      function(parallelCallback) {
        var timeframeOptions = {
          pageId: options.pageId,
          sectionId: options.sectionId,
          timeframe: options.timeframe,
          callback: function(impressions) {
            parallelCallback(null, impressions);
          }
        };
        impressionCount(timeframeOptions);
      }
    ], 
    function(err, results) {
      var totalSectionImpressions = results[0],
          sectionImpressionsSince = results[1],
          diffInImpressions = totalSectionImpressions - sectionImpressionsSince,
          growth = diffInImpressions > 0 ? ((sectionImpressionsSince / diffInImpressions) * 100) : 0;
          
      options.callback(growth);
    });
  };
  
  function mostPopular(options)
  {
    Keen.onChartsReady(function() {
      var metric = new Keen.Metric(eventCollection, {
        analysisType: "count",
        filters: [{
          property_name: "page_id",
          operator: "eq",
          property_value: options.pageId
        }],
        groupBy: ["section_id", "section_type"]
      });
      
      if(options.timeframe) {
        metric.timeframe(options.timeframe);
      }

      metric.getResponse(function(response){
        if(!options.callback) return;
        
        var sections = response.result;
        var sortedSections = _.sortBy(sections, function(section) {
          return section.result;
        })
        options.callback(sortedSections.reverse());
      });
    });
  };
  
  function leastPopular(options)
  {
    Keen.onChartsReady(function() {
      var metric = new Keen.Metric(eventCollection, {
        analysisType: "count",
        filters: [{
          property_name: "page_id",
          operator: "eq",
          property_value: options.pageId
        }],
        groupBy: ["section_id", "section_type"]
      });
      
      if(options.timeframe) {
        metric.timeframe(options.timeframe);
      }

      metric.getResponse(function(response){
        if(!options.callback) return;
        
        var sections = response.result;
        var sortedSections = _.sortBy(sections, function(section) {
          return section.result;
        })
        options.callback(sortedSections);
      });
    });
  };
  
  window.PageImpressionStats = PageImpressionStats;
}(window));




