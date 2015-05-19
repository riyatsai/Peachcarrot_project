Parse.initialize("fonWQnx1RDOHSy5emNfTb76JOHZtwe37lOJzRnnD","C93Pwv3bwZswToCw4ARTx20hp7ZYLnbNfVcFnQyp");
  
  var TestObject = Parse.Object.extend("TestObject");
  var testObject = new TestObject();
    testObject.save({foo: "bar"}, {
    success: function(object) {
      $(".success").show();
    },
    error: function(model, error) {
      $(".error").show();
    }
  });    
  
  
  
  
var Craft = Parse.Object.extend("craft");
var craft = new Craft();
craft.save({name:"three"},{sucess:function(craft){console.log('gooooood');
	},error:function(craft,error){alert('there is a problem.');
	}});
	