function showHide( elementID ) {
	var e = document.getElementById(elementID);
	if (e.style.display === "none") {
		e.style.display = "block";
	} else {
		e.style.display = "none";
	}
}