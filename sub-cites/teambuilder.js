var pokeTeam = ["", "", "", "", "", "", ""];
clearTeam();
		
function addToTeam() {
	var pokeName = document.getElementById("search").value;
	pokeName = pokeName.trim();
	pokeName = pokeName.toLowerCase();
	var notAssigned = true;
	var index = 0;
	while(notAssigned && index < 6) {
		if(pokeTeam[index] == "") {
			pokeTeam[index] = pokeName.toLowerCase();
			var pokeImage =	document.getElementById("poke" + index)
			pokeImage.src = "http://www.smogon.com/dex/media/sprites/xy/" + pokeName.toLowerCase() + ".gif";
			pokeImage.style.visibility = "visible";
			notAssigned = false;
		}
		index = index + 1;
	}
}

function removePoke(pokeIndex) {
	pokeTeam[pokeIndex] = "";
	var pokeImage =	document.getElementById("poke" + pokeIndex)
	pokeImage.src = "";
	pokeImage.style.visibility = "hidden";
}

function switchPoke(index1, index2) {
	var tempPoke = pokeTeam[index1];
	pokeTeam[index1] = pokeTeam[index2];
	pokeTeam[index2] = tempPoke;
	var pokemon1 = document.getElementById("poke" + index1);
	var pokemon2 = document.getElementById("poke" + index2);
	pokemon1.src = "http://www.smogon.com/dex/media/sprites/xy/" + pokeTeam[index1] + ".gif";
	pokemon2.src = "http://www.smogon.com/dex/media/sprites/xy/" + pokeTeam[index2] + ".gif";
	if(pokeTeam[index1] == "") {
		pokemon1.style.visibility = "hidden";
	}
	else {
		pokemon1.style.visibility = "visible";
	}
	if(pokeTeam[index2] == "") {
		pokemon2.style.visibility = "hidden";
	}
	else {
		pokemon2.style.visibility = "visible";
	}
	
}

function clearTeam() {
	for(var i = 0; i < 6; i++) {
		pokeTeam[i] = "";
		var pokeImage = document.getElementById("poke" + i);
		pokeImage.src = "";
		pokeImage.alt = "Pokemon" + i;
		pokeImage.style.visibility = "hidden";
	}	
}