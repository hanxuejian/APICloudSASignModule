function getSignImage() {
    var demo = api.require('SASignModule');
    demo.showSignView({
                      path: 'fs://0012.png',
                      width: 100,
                      height:100
                   },function(ret, err){
                      var data = ret.imageData;
                      alert(data);
                      alert(ret.path);
                      alert(ret.isImageWriteSuccess);
                   });
}