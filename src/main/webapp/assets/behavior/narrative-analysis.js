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

            this.uncollapseClass = "uncollapse";
            this.openClass = "open";
            this.narrativeText = "narrativeText";
            this.displayedClass = "displayed";
            this.hiddenClass = "hidden";
            this.lastClass = "last";

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

        narrativesClickListener() {

            if (event.target.classList.contains(this.narrativeText)) {
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