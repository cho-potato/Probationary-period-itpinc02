function gfn_isNull(str) {
	if (str == null) return true;
	if (str == "NaN") return true;
	if (new String(str).valueOf() == "undefined") return true;    
    var chkStr = new String(str);
    if( chkStr.valueOf() == "undefined" ) return true;
    if (chkStr == null) return true;    
    if (chkStr.toString().length == 0 ) return true;   
    return false; 
}

function ComSubmit(opt_formId)  //-> 입력한 폼아이디값
{
	this.formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
	this.url = "";
	this.target = "_self";
	this.popupTarget = "popup";
	if(this.formId == "commonForm"){
		$("#commonForm")[0].reset();
	}else{
		$("#"+opt_formId)[0].reset();
	}
	
	
	
	this.setUrl = function setUrl(url){
		this.url = url;
	};
	
	this.setTarget = function setTarget(target){
		this.target = target;
		
	}
	
	this.addParam = function addParam(key, value)
	{
		var frmKey = $('input[name='+key+']').val();
		console.log(frmKey);
		if(typeof frmKey === 'undefined'){
			$("#"+this.formId).append($("<input type='hidden' name='"+key+"'id='"+key+"' value='"+value+"'>"));
		}else{
			$("#"+this.formId).find('input[name='+key+']').val(value);
			
		}
	};
	
	this.submit = function submit()
	{
		var frm = $("#"+this.formId)[0];
		frm.action = this.url;
		frm.target = this.target;
		frm.method = "post";
		frm.submit();	
	};
	
	this.popup = function popup(){
		var frm = $("#"+this.formId)[0];
		frm.action = this.url;
		frm.target = this.popupTarget;
		frm.method = "post";
		window.open("", this.popupTarget, "width=400, height=300, left=100, top=50");
		frm.submit();
		
	}
	
}

 var gfv_ajaxCallback = "";
 
 function ComAjax(opt_formId)
 {
	 this.url = "";
	 this.formId = gfn_isNull(opt_formId) == true?"commonForm":opt_formId;
	 this.param = "";
	 
	 if(this.formId == "commonForm")
	 {
		 var frm = $("#commonForm");
		 if(frm.length>0){
			 frm.remove();
		 }
		 
		 var str = "<form id='commonForm' name='commonForm'></form>";
		 $('body').append(str);
	 }
	 
	 this.setUrl = function setUrl(url)
	 {
		 this.url = url;
	 };
	 
	 this.setCallback = function setCallback(callBack)
	 {
		 fv_ajaxCallback = callBack;
	 };
	 
	 this.addParam = function addParam(key, value)
	 {
		 this.param = this.param + "&" + key + "=" + value;
	 };
	 
	 this.ajax = function ajax()
	 {
		 if(this.formId != "commonForm"){
			 this.param += "&" + $("#" + this.formId).serialize();
		 }
		 $.ajax({
			 url : this.url,
			 type : "post",
			 data : this.param,
			 async : false,
			 success : function(data, status){
				 if(typeof(fv_ajaxCallback) == "function"){
					 fv_ajaxCallback(data);
				 }else{
					 eval(fv_ajaxCallback + "(data);");
				 }
			 }
		 });	 
	 };
 }
 
 //페이징 태그부분
 /*
  * divId : 페이징 태그가 그려질 div
  * pageIndx : 현재 페이지 위치가 저장될 input 태그 id
  * recordCount : 페이지당 레코드 수
  * totalCount : 전체 조회 건수
  * eventName : 페이징 하단의 숫자 등의 버튼이 클릭되었을때 호출될 함수 이름
  */
 
 var gfv_pageIndex = null;
 var gfv_eventName = null;
 
 function gfn_renderPaging(params)
 {
	 var divId = params.divId; //페이징이 그려질 div id
	 gfv_pageIndex = params.pageIndex; //현재 위치가 저장될 input 태그
	 var totalCount = params.totalCount; //전체 조회 건수
	 var currentIndex = $("#"+params.pageIndex).val(); //현재 위치
	 if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
		 currentIndex = 1;
	 }
	 
	 var recordCount = params.recordCount; //페이지당 레코드 수
	 if(gfn_isNull(recordCount) == true){
		 recordCount = 20;
	 }
	 
	 var totalIndexCount = Math.ceil(totalCount/recordCount); //전체 인덱스 수
	 gfn_eventName = params.eventName;
	 /*
	  * Math.floor : 소수점 버림
	  * Math.ceil : 소수점 올림
	  * Math.round : 반올림
	  * Math.random : 랜덤함수
	  * Math.sqrt : 제곱근
	  * Math.pow : 제곱
	  * Math.abs : 절대값
	  */
	 
	 $("#"+divId).empty();
	 var preStr = "";
	 var postStr = "";
	 var str = "";
	 
	 var first = (parseInt((currentIndex-1)/10)*10) + 1;
	 var last = (parseInt(totalCount/10)==parseInt(currentIndex/10))?totalIndexCount%10:10;
	 var prev = (parseInt((currentIndex-1)/10)*10) - 9 > 0 ? (parseInt((currentIndex-1)/10)*10) - 9 : 1; 
	 var next = (parseInt((currentIndex-1)/10)+1) * 10 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/10)+1) * 10 + 1 : totalIndexCount;

	 if(totalIndexCount>10){
		 preStr += "<a href='#this' class='pad_5' onclick='_movePage(1)'>[<<]</a>"
	 }
	 
	 
 }