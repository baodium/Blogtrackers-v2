/*



	" Reimplement the wheel to either learn, or make it better. "

    http://www.haydex.com/
    https://www.youtube.com/watch?v=QOlTGA3RE8I
    
    Product Name: Btracker
	Description: Tracking Blog's data.
	Beneficiary: COSMOS
	
	Copyright © 1988 - 2020 HAYDEX, All Rights Reserved.
	
	
	
*/



document.addEventListener("DOMContentLoaded", function() {

    // General

    class General {

        constructor() {

            this.keywords = document.querySelectorAll("ul#narrativeTree li.level div.keyword");
            this.narratives = document.querySelectorAll("ul#narrativeTree li.level ul.narratives li.narrative");

            this.uncollapseClass = "uncollapse";
            this.openClass = "open";

            this.initialize();

        }

        initialize() {

            for (let i = 0; i < this.keywords.length; i++) {

                this.keywords[i].addEventListener("click", this.keywordsClickListener.bind(this));

            }

            for (let i = 0; i < this.narratives.length; i++) {

                this.narratives[i].addEventListener("click", this.narrativesClickListener.bind(this));

            }

        }

        keywordsClickListener() {

            event.currentTarget.parentNode.classList.toggle(this.uncollapseClass);

        }

        narrativesClickListener() {

            event.currentTarget.classList.toggle(this.openClass);

        }

    }

    // Initialization

    let general = new General();

});