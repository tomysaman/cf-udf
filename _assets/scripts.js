function showHide( elementID ) {
	var e = document.getElementById(elementID);
	var dsp = window.getComputedStyle(e).display;
	if (dsp === "none") {
		e.style.display = "block";
	} else {
		e.style.display = "none";
	}
}