

function Uploader(drop_target_id, upload_url) {

	var drop_target = document.getElementById(drop_target_id);

	drop_target.addEventListener("dragover", function(e) {
		e.stopPropagation(); 
		e.preventDefault();
		drop_target.className = "drop_now";
	}, true);

	drop_target.addEventListener("dragleave", function(e) {
		drop_target.className = "";
		console.log("dragout");
	})

	drop_target.addEventListener("drop", function(e) {
		e.preventDefault();
		var files = e.target.files || e.dataTransfer.files;
		console.log(files);

		for (var i=0; i<1; i++) {
			var xhr = new XMLHttpRequest();
			xhr.open("POST", upload_url);
			xhr.onload = function(e) { console.log(e.target.response); };
			xhr.onprogress = function(e) {};

			var form = document.getElementById("uploadform");
			var form_data = new FormData(form);
			form_data.append('file', files[i]);
			xhr.send(form_data);
		}

	}, false);


	
}

	