function transform_batch_data(line) {
  var values = line.split(',');

  var obj = new Object();
  obj.state = values[0];
  obj.gender = values[1];
  obj.year = [values[2], "01", "01"].join("-");
  obj.name = values[3];
  obj.number = parseInt(values[4]);
  obj.created_date = values[5];

  return JSON.stringify(obj);
}

function transform_streaming_data(payload) {
  payload = JSON.parse(payload)
  
  payload.year = [payload.year, "01", "01"].join("-");
  payload.number = parseInt(payload.number);

  return JSON.stringify(payload);
}