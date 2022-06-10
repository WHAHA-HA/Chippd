//= require underscore

// PageVisitsStats provides an interface to get
// statistics about Page Visits.
//
// <--- Usage ---> 
//
// Page visit stats:
// 
// var pageVisitStats = PageVisitStats.forPage(pageId);
// pageVisitStats.total.uniqueViewers(callbackFn); // 10
// pageVisitStats.day.uniqueViewers(callbackFn); // 10
// pageVisitStats.week.uniqueViewers(callbackFn); // 10
// pageVisitStats.month.uniqueViewers(callbackFn); // 10

// pageVisitStats.total.repeatViewers(callbackFn); // 50
// pageVisitStats.day.repeatViewers(callbackFn); // 50
// pageVisitStats.week.repeatViewers(callbackFn); // 50
// pageVisitStats.month.repeatViewers(callbackFn); // 50

// pageVisitStats.total.averageVisitsPerUser(callbackFn);  // 50
// pageVisitStats.day.averageVisitsPerUser(callbackFn);  // 50
// pageVisitStats.week.averageVisitsPerUser(callbackFn);  // 50
// pageVisitStats.month.averageVisitsPerUser(callbackFn);  // 50

// pageVisitStats.day.growth(callbackFn);
// pageVisitStats.week.growth(callbackFn);
// pageVisitStats.month.growth(callbackFn);

(function(window) {
  var eventCollection = 'visits';
  
  var PageVisitStats = {    
    forPage: function(pageId) {
      var pageStats = {};
      
      // creates stat functions for each of the timeframes
      // Eg., total.dataUsed(fn), total.impressions(fn), total.mostPopular(fn), total.leastPopular(fn)
      // creates these functions for total, day, week, month
      _.each(['total', 'day', 'week', 'month'], function(timeframe) {        
        pageStats[timeframe] = {};
        
        var statFns = {
          uniqueViewers: uniqueViewers,
          repeatViewers: repeatViewers,
          averageVisitsPerUser: averageVisitsPerUser,
          growth: growth
        };
        
        _.each(statFns, function(statFn, statName) {
          if(timeframe == 'total' && statName == 'growth') return;
          
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

      
      pageStats.viewersAfter = function (options) {
        if (!options || !options.callback) { return; }
        options.pageId = pageId;
        return viewersAfter(options);
      };

      return pageStats;
    }
  };
  

  // options = { pageId: '', timeframe: '', callback: function() }
  function uniqueViewers(options) 
  {
    Keen.onChartsReady(function() {
      var metric = new Keen.Metric(eventCollection, {
        analysisType: "count_unique",
        targetProperty: "customer_id",
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
        options.callback(response.result);
      });
    });
  };

  function repeatViewers(options) 
  {
    Keen.onChartsReady(function() {
      var metric = new Keen.Metric(eventCollection, {
        analysisType: "count",
        filters: [{
          property_name: "page_id",
          operator: "eq",
          property_value: options.pageId
        }],
        groupBy: "customer_id"
      });
      
      if(options.timeframe) {
        metric.timeframe(options.timeframe);
      }

      metric.getResponse(function(response){
        if(!options.callback) return;
        
        var result = response.result;
        var sum = 0;
        _.each(result, function(user) {
          sum += user.result;
        });
        
        options.callback(sum);
      });
    });
  };
  
  function averageVisitsPerUser(options) 
  {
    Keen.onChartsReady(function() {
      var metric = new Keen.Metric(eventCollection, {
        analysisType: "count",
        filters: [{
          property_name: "page_id",
          operator: "eq",
          property_value: options.pageId
        }],
        groupBy: "customer_id"
      });
      
      if(options.timeframe) {
        metric.timeframe(options.timeframe);
      }

      metric.getResponse(function(response){
        if(!options.callback) return;
        
        var result = response.result;
        var sum = 0;
        _.each(result, function(user) {
          sum += user.result;
        });
        
        var avg = result.length > 0 ? (sum / result.length) : 0;
        
        options.callback(avg);
      });
    });
  };
  
  function growth(options)
  {
    if(!options.callback) return;
    
    async.parallel([
      // get total visits
      function(parallelCallback) {
        var totalOptions = {
          pageId: options.pageId,
          callback: function(visits) {
            parallelCallback(null, visits);
          }
        };
        uniqueViewers(totalOptions);
      }, 
      // get visits for timeframe
      function(parallelCallback) {
        var timeframeOptions = {
          pageId: options.pageId,
          timeframe: options.timeframe,
          callback: function(visits) {
            parallelCallback(null, visits);
          }
        };
        uniqueViewers(timeframeOptions);
      }
    ], 
    function(err, results) {
      var totalVisitors = results[0],
          visitorsSince = results[1],
          diffInVisitors = totalVisitors - visitorsSince,
          growth = diffInVisitors > 0 ? ((visitorsSince / diffInVisitors) * 100) : 0;
          
      options.callback(growth);
    });
  };

  function viewersAfter(options) {
    if (!options || !options.callback) return;

    var uniqueOptions = {
      pageId: options.pageId,
      timeframe: options.timeframe,
      callback: options.callback
    };

    uniqueViewers(uniqueOptions);
  };
  
  window.PageVisitStats = PageVisitStats;
}(window));




