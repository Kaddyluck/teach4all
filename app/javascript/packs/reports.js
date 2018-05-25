import Chart from 'chart.js';
var ctx = document.getElementById("pieChart");
var pieData = $("#pieData").data();
var sum = pieData.passing + pieData.finishedSuccessfully + pieData.finishedUnsuccessfully;
var data = [
  (pieData.passing / sum * 100).toFixed(2), 
  (pieData.finishedSuccessfully / sum * 100).toFixed(2),
  (pieData.finishedUnsuccessfully / sum * 100).toFixed(2)
];
var pieChart = new Chart(ctx, {
  type: 'pie',
  data: {
    datasets: [{
      data: data,
      backgroundColor: ["#3498db", "#2ecc71", "#f1c40f"],
      hoverBackgroundColor: ["#2980b9", "#27ae60", "#f39c12"]
    }],
    labels: [
      'Passing',
      'Finished successfully',
      'Finished unsuccessfully'
    ]
  },
  options: {
  }
});