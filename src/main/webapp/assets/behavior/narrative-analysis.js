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

            this.body = document.querySelector("body");
            this.keywords = document.querySelectorAll("ul#narrativeTree li.level div.keyword");
            this.narrativesList = document.querySelectorAll("ul#narrativeTree li.level ul.narratives");
            this.narratives = document.querySelectorAll("ul#narrativeTree li.level ul.narratives li.narrative");
            this.posts = document.querySelectorAll("ul#narrativeTree li.level ul.narratives li.narrative div.posts div.post");
            this.moreButton = document.querySelectorAll("ul#narrativeTree li.level ul.narratives li.narrative.more");
            this.moreInfoModal = document.querySelector("section#moreInfoModal");
            this.moreInfoModalShadow = document.querySelector("section#moreInfoModal div#shadow");
            this.moreInfoModalContent = document.querySelector("section#moreInfoModal div#messageContent");
            this.moreInfoCloseButton = document.querySelector("section#moreInfoModal div#messageBox button#closeButton");
            this.bottomMessage = document.querySelector("section#notifications");
            this.narrativeEditButton = "editButton";
            this.narrativeConfirmButton = "confirmButton";
            this.narrativeCancelButton = "cancelButton";

            this.uncollapseClass = "uncollapse";
            this.openClass = "open";
            this.narrativeText = "narrativeText";
            this.displayedClass = "displayed";
            this.hiddenClass = "hidden";
            this.lastClass = "last";
            this.editingClass = "editing";
            this.previousContent = "";

            this.freezeDocumentScrollingClass = "freeze";

            this.initialize();

        }

        initialize() {
            for (let i = 0; i < this.moreButton.length; i++) {

                this.moreButton[i].addEventListener("click", this.morebuttonClickListener.bind(this));

            }

            for (let i = 0; i < this.keywords.length; i++) {

                this.keywords[i].addEventListener("click", this.keywordsClickListener.bind(this));

            }

            for (let i = 0; i < this.narratives.length; i++) {

                this.narratives[i].addEventListener("click", this.narrativesClickListener.bind(this));
               
            }

            for (let i = 0; i < this.posts.length; i++) {

                this.posts[i].addEventListener("click", this.postsClickListener.bind(this));

            }

            this.moreInfoCloseButton.addEventListener("click", this.moreInfoCloseButtonClickListener.bind(this));
            this.moreInfoModalShadow.addEventListener("click", this.moreInfoModalShadowClickListener.bind(this));
            document.addEventListener("keydown", this.escapeKeyListener.bind(this));
            
            $("body").delegate(".narrative_text_test", "click", function() {
            	
            	if($("#narrative_pop_"+$(this).attr("count")).hasClass("open")){
            		$("#narrative_pop_"+$(this).attr("count")).removeClass("open")
            	}else{
            		$("#narrative_pop_"+$(this).attr("count")).addClass("open")
            	}
            	
            });
            
            //START Keyword click delegate
            $("body").delegate(".keyword1", "click", function() {
            	
            	if ($(this).parent('li').hasClass("uncollapse")){
            		$(this).parent('li').removeClass("uncollapse");
        		} else {
        			$(this).parent('li').addClass("uncollapse");
        		}
            	
            });
            //END Keyword click delegate
            
            //START Narrative click delegate
	        $("body").delegate(".narrative_text_input", "click", function() {
	        	
	        	if ($(this).parent('div').parent('div').parent('li').hasClass("open")){
	        		$(this).parent('div').parent('div').parent('li').removeClass("open");
	    		} else {
	    			$(this).parent('div').parent('div').parent('li').addClass("open");
	    		}
	        	
	        });
	        //END Narrative click delegate
            
            

        }
        
        

        morebuttonClickListener() {

            for (let i = 0; i < this.narratives.length; i++) {

                this.narratives[i].classList.remove(this.hiddenClass);

            }

            this.moreButton[0].previousElementSibling.classList.add(this.lastClass)
            this.moreButton[0].remove();

        }

        keywordsClickListener() {

            event.currentTarget.parentNode.classList.toggle(this.uncollapseClass);

        }

        narrativesClickListener(event) {


            if (event.target.id == this.narrativeEditButton) {

                event.currentTarget.classList.toggle(this.editingClass);
                event.currentTarget.getElementsByClassName(this.narrativeText)[0].setAttribute("contenteditable", "true");
                event.currentTarget.getElementsByClassName(this.narrativeText)[0].focus();
                this.previousContent = event.currentTarget.getElementsByClassName(this.narrativeText)[0].textContent;

            }

            if (event.target.id == this.narrativeConfirmButton) {

                event.currentTarget.classList.toggle(this.editingClass);
                event.currentTarget.getElementsByClassName(this.narrativeText)[0].setAttribute("contenteditable", "false");

            }

            if (event.target.id == this.narrativeCancelButton) {

                event.currentTarget.classList.toggle(this.editingClass);
                event.currentTarget.getElementsByClassName(this.narrativeText)[0].setAttribute("contenteditable", "false");
                event.currentTarget.getElementsByClassName(this.narrativeText)[0].textContent = this.previousContent;

            }

            if (event.target.classList.contains(this.narrativeText) && !(event.currentTarget.classList.contains(this.editingClass))) {
                event.currentTarget.classList.toggle(this.openClass);
                if (this.bottomMessage) this.bottomMessage.remove();
            }

        }

        postsClickListener() {

            this.freezeDocumentScrolling();
            this.moreInfoModal.classList.add(this.displayedClass);
            this.resetScrolling(this.moreInfoModalContent);

        }

        moreInfoCloseButtonClickListener() {

            this.moreInfoModal.classList.remove(this.displayedClass);
            this.unfreezeDocumentScrolling();

        }

        moreInfoModalShadowClickListener() {

            this.moreInfoModal.classList.remove(this.displayedClass);
            this.unfreezeDocumentScrolling();

        }

        freezeDocumentScrolling() {

            this.body.classList.add(this.freezeDocumentScrollingClass);

        }

        unfreezeDocumentScrolling() {

            this.body.classList.remove(this.freezeDocumentScrollingClass);

        }

        resetScrolling(object) {

            object.scrollTop = 0;

        }

        escapeKeyListener() {

            if (window.event.keyCode == 27) {
                this.moreInfoCloseButtonClickListener();
            }
        }

    }

    // Initialization

    let general = new General();

});