({
    createGraph : function(cmp, temp) {
        
        var dataMap = {"chartLabels": Object.keys(temp),
                       "chartData": Object.values(temp)
                      };
        var positiveBalance = [];
        var negativeBalance = [];
        var el = cmp.find('barChart').getElement();
        var ctx = el.getContext('2d');
        for(var a=0; a< dataMap.chartData.length; a++){
            if(dataMap.chartData[a]>0){
                positiveBalance.push(dataMap.chartData[a]);
            }else{
                negativeBalance.push(dataMap.chartData[a]);
            }                     
        }
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [{
                    label: 'Available Balance',
                    data: positiveBalance,
                    backgroundColor: "rgba(68,186,93,0.8)"
                }, {
                    label: 'Due Balance',
                    data: negativeBalance,
                    backgroundColor: "rgba(246,77,82,0.9)"
                }]
            },
            options : {
            scales: {
                xAxes: [{
                    barPercentage: 1.0,
                    gridLines: {
                        display: false
                    }
                }],
                
            }
        }
                  });
    },
    
})