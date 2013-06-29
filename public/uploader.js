

function Uploader(drop_target_id, upload_url) {

	var uploader = this;
	var drop_target = document.getElementById(drop_target_id);

	drop_target.addEventListener("dragover", function(e) {
		e.stopPropagation(); 
		e.preventDefault();
		drop_target.className = "drop_now";
	}, true);

	drop_target.addEventListener("dragleave", function(e) {
		drop_target.className = "";
	})

	drop_target.addEventListener("drop", function(e) {
		e.preventDefault();
		drop_target.className = "";
		
		var files = e.target.files || e.dataTransfer.files;
		
		for (var i=0; i<files.length; i++) {
			uploader.upload(files[i]);
		}
		
	}, false);

	this.upload = function(input) {
		var upload_feedback = document.createElement("div");
		upload_feedback.className = "upload feedback";
		var upload_title = document.createElement("span");
		upload_title.innerHTML = (input instanceof File) ? input.name : "Uploading...";
		upload_feedback.appendChild(upload_title);
		var upload_progress = document.createElement("div");
		upload_progress.className = "progress";
		upload_feedback.appendChild(upload_progress);
		document.getElementById("container").appendChild(upload_feedback);

		var ajax = new XMLHttpRequest();
		ajax.onreadystatechange = function() {
			if (ajax.readyState==4 && ajax.status==200) {
				upload_feedback.className += " done";
				upload_title.innerHTML = ajax.responseText;
			}
		}
		ajax.upload.onprogress = function(ev) {
			upload_progress.style.width = ev.loaded/ev.total * 100 + "%";
		}

		var form_data;
		if (input instanceof File) {
			form_data = new FormData();
			form_data.append('file', input);
		} else {
			form_data = new FormData(input);
		}
		form_data.append('ajax', true);
		ajax.open("POST", upload_url);
		ajax.send(form_data);
	}
	
}

	