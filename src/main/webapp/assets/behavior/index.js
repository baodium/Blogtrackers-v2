/*



	" Reimplement the wheel to either learn, or make it better. "

    http://www.haydex.com/
    https://www.youtube.com/watch?v=QOlTGA3RE8I
    
    Product Name: Btracker
	Description: Tracking Blog's data.
	Beneficiary: COSMOS
	
	Copyright © 1988 - 2021 HAYDEX, All Rights Reserved.
	
	
	
*/



document.addEventListener("DOMContentLoaded", function() {

    // General

    class General {

        constructor() {

            this.body = document.querySelector("body");
            this.tree = document.querySelector("ul#narrativeTree");
            this.keywords = document.querySelectorAll("ul#narrativeTree li.level div.keyword");
            this.keywordList = document.querySelectorAll("ul#narrativeTree li.level div#keywordWrapper.group div#keywordList");
            this.collapseIcons = document.querySelectorAll("ul#narrativeTree li.level div#collapseIcon");
            this.radioButtons = document.querySelectorAll("ul#narrativeTree li.level div#keywordWrapper button#radioButton");
            this.ungroupButtons = document.querySelectorAll("ul#narrativeTree li.level div#keywordWrapper button#ungroupButton");
            this.removeKeyword = document.querySelectorAll("ul#narrativeTree li.level div#keywordWrapper div.keyword button#removeKeyword");
            this.level = document.querySelectorAll("ul#narrativeTree li.level");
            this.narrativesList = document.querySelectorAll("ul#narrativeTree li.level ul.narratives");
            this.narratives = document.querySelectorAll("ul#narrativeTree li.level ul.narratives li.narrative");
            this.posts = document.querySelectorAll("ul#narrativeTree li.level ul.narratives li.narrative div.posts div.post");
            this.moreButton = document.querySelectorAll("ul#narrativeTree li.level ul.narratives li.narrative.more");
            this.moreInfoModal = document.querySelector("section#moreInfoModal");
            this.moreInfoModalShadow = document.querySelector("section#moreInfoModal div#shadow");
            this.moreInfoModalContent = document.querySelector("section#moreInfoModal div#messageContent");
            this.moreInfoCloseButton = document.querySelector("section#moreInfoModal div#messageBox button#closeButton");
            this.notifications = document.querySelector("section#notifications");
            this.notificationsMergeButton = document.querySelector("section#notifications div#mergeMessage button#mergeButton");
            this.notificationsCounter = document.querySelector("section#notifications span#counter");
            this.editKeywordsButton = document.querySelector("section#notifications button#editKeywords");
            this.cancelEditingButton = document.querySelector("section#notifications button#cancelEditing");
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
            this.selectedClass = "selected";
            this.closeButton = "closeButton";
            this.previousContent = "";
            this.enabledClass = "enabled";
            this.groupClass = "group";
            this.selectionCounter = 0;
            this.editMode = false;

            this.freezeDocumentScrollingClass = "freeze";

            this.initialize();

        }

        initialize() {

            for (let i = 0; i < this.removeKeyword.length; i++) {

                this.removeKeyword[i].addEventListener("click", this.removeKeywordClickListener.bind(this));

            }

            for (let i = 0; i < this.keywordList.length; i++) {

                this.keywordList[i].addEventListener("click", this.keywordListClickListener.bind(this));

            }

            for (let i = 0; i < this.ungroupButtons.length; i++) {

                this.ungroupButtons[i].addEventListener("click", this.ungroupButtonClickListener.bind(this));

            }

            for (let i = 0; i < this.moreButton.length; i++) {

                this.moreButton[i].addEventListener("click", this.morebuttonClickListener.bind(this));

            }

            for (let i = 0; i < this.keywords.length; i++) {

                this.keywords[i].addEventListener("click", this.keywordsClickListener.bind(this));

            }

            for (let i = 0; i < this.collapseIcons.length; i++) {

                this.collapseIcons[i].addEventListener("click", this.collapseIconsClickListener.bind(this));

            }

            for (let i = 0; i < this.narratives.length; i++) {

                this.narratives[i].addEventListener("click", this.narrativesClickListener.bind(this));
                
            }

            for (let i = 0; i < this.posts.length; i++) {

                this.posts[i].addEventListener("click", this.postsClickListener.bind(this));

            }

            this.moreInfoCloseButton.addEventListener("click", this.moreInfoCloseButtonClickListener.bind(this));
            this.moreInfoModalShadow.addEventListener("click", this.moreInfoModalShadowClickListener.bind(this));
            this.notifications.addEventListener("click", this.notificationsClickListener.bind(this));
            // this.notificationsMergeButton.addEventListener("click", this.notificationsMergeButtonClickListener.bind(this));
            document.addEventListener("keydown", this.escapeKeyListener.bind(this));
            this.cancelEditingButton.addEventListener("click", this.cancelEditingButtonClickListener.bind(this));
            this.editKeywordsButton.addEventListener("click", this.editKeywordsButtonClickListener.bind(this));
            
            
      ///////
//            $("body").delegate("#editKeywords", "click", function() {
//            	alert("eddy")
//            	//this.editKeywordsButtonClickListener.bind(this)
//            	if (!this.editMode) {
//                	
//                	
//                    this.cancelEditingButton.classList.toggle(this.editingClass);
//                    this.editMode = !this.editMode;
//                    this.editKeywordsButton.classList.toggle(this.hiddenClass);
//                    this.tree.classList.toggle(this.editingClass);
//                    this.editKeywordsButton.querySelector("div#counter").classList.remove(this.displayedClass);
//                    this.editKeywordsButton.querySelector("div#counter").classList.remove("hidden");
//                    alert("edit mode 122")
//                    $("#editKeywords").removeClass('hidden');
//                } 
//            	//entity = $(this).attr("entity")
//            	//$("#".entity).setAttribute("contenteditable", "true");
////            	event.currentTarget.classList.toggle("editing");
////                event.currentTarget.getElementsByClassName("narrativeText")[0].setAttribute("contenteditable", "true");
////                event.currentTarget.getElementsByClassName("narrativeText")[0].focus();
////                this.previousContent = event.currentTarget.getElementsByClassName("narrativeText")[0].textContent;
//            	
//            });
            /////
        }

        removeKeywordClickListener(event) {

            
            var keywords = event.currentTarget.parentNode.parentNode.querySelectorAll("div.keyword");

            console.log(keywords.length);

            if (keywords.length < 3) {

                
                event.currentTarget.parentNode.parentNode.parentNode.parentNode.classList.remove("group")

            }

            event.currentTarget.parentNode.remove();
            

        }

        editKeywordsButtonClickListener(event) {

            if (!this.editMode) {
            	
            	
            	
            	

                this.cancelEditingButton.classList.toggle(this.editingClass);
                this.editMode = !this.editMode;
                this.editKeywordsButton.classList.toggle(this.hiddenClass);
                this.tree.classList.toggle(this.editingClass);
                this.editKeywordsButton.querySelector("div#counter").classList.remove(this.displayedClass);
                this.editKeywordsButton.querySelector("div#counter").classList.remove("hidden");
                //alert("edit mode 122")
                $("#editKeywords").removeClass('hidden');
            } else {
            	
            	//alert("not edit mode")

                if (this.selectionCounter > 1) {
                	
                	//start merging
                	merge_entities();
                	//end merging

                    var keywordList = this.tree.querySelectorAll("div#keywordList.selected");

                    for (var i=0; i < keywordList.length; i++) {

                        keywordList[i].classList.remove(this.selectedClass);

                    }

                    let levelClone = this.tree.lastElementChild.cloneNode(true);
                    
                    levelClone.querySelector("div#keywordList").innerHTML = "";
                    levelClone.querySelector("div#keywordWrapper").classList.add(this.groupClass);
                    levelClone.querySelector("div#keywordList").classList.remove("selected");
                    var narratives = levelClone.querySelectorAll("li.narrative");

                    for (i=0; i < narratives.length; i++) {

                        narratives[i].classList.remove("open");
                        narratives[i].classList.remove("editing");
                        narratives[i].querySelector("p.narrativeText").setAttribute("contenteditable", "false");
                    }

                    levelClone.classList.remove("uncollapse");

                    this.tree.appendChild(levelClone);

                    let seletedKeywords = this.tree.querySelectorAll("div.keyword.selected");

                    for (let i=0; i < seletedKeywords.length; i++) {

                        let clone = seletedKeywords[i].cloneNode(true);
                        clone.classList.remove(this.selectedClass);
                        this.tree.lastElementChild.querySelector("div#keywordList").appendChild(clone);

                    }

                    let selectedKeywords = this.tree.querySelectorAll("div.keyword.selected");

                    for (let i=0; i < seletedKeywords.length; i++) {

                        selectedKeywords[i].classList.remove(this.selectedClass);

                    }

                    this.tree.lastElementChild.scrollIntoView({
                        block: "start",
                        behavior: "smooth",
                      });

                    
                    this.selectionCounter = 0;
                    this.updateCounter();

                    var keywords = this.tree.lastElementChild.querySelectorAll("div.keyword");
                    this.tree.lastElementChild.querySelector("div#keywordList").addEventListener("click", this.keywordListClickListener.bind(this));
                    this.tree.lastElementChild.querySelector("div#collapseIcon").addEventListener("click", this.collapseIconsClickListener.bind(this));
                    var removeKeyword = this.tree.lastElementChild.querySelectorAll("button#removeKeyword");

                    for (var i=0; i < keywords.length; i++) {

                        keywords[i].addEventListener("click", this.keywordsClickListener.bind(this));

                    }

                    var narratives = this.tree.lastElementChild.querySelectorAll("li.narrative");
                    var posts = this.tree.lastElementChild.querySelectorAll("div.post");

                    for (let i = 0; i < narratives.length; i++) {

                        narratives[i].addEventListener("click", this.narrativesClickListener.bind(this));
        
                    }
        
                    for (let i = 0; i < posts.length; i++) {
        
                        posts[i].addEventListener("click", this.postsClickListener.bind(this));
        
                    }

                    for (let i = 0; i < removeKeyword.length; i++) {

                        removeKeyword[i].addEventListener("click", this.removeKeywordClickListener.bind(this));
        
                    }
                    
                }
            }

        }

        keywordListClickListener(event) {
        	//alert("k mode")
            if (this.editMode) {
            //	alert("p mode")
                event.currentTarget.classList.toggle(this.selectedClass);
                
                event.currentTarget.classList.toggle("hghyghgy");
                
                if($(this).hasClass("entity_unselected")){
                	//alert(" have")
                	$(this).addClass("entity_selected")
            		$(this).removeClass("entity_unselected")
            	}else{
            		//alert("doesnt have")
            		//remove from array
            		//$(this).parent('div').removeClass("selected");
            		$(this).removeClass("entity_selected")
            		$(this).addClass("entity_unselected")
            		
            	}	

                var keywords = event.currentTarget.querySelectorAll("div.keyword");

                if (event.currentTarget.classList.contains(this.selectedClass)) {

                    for (var i = 0; i < keywords.length; i++) {

                        
                        if (!keywords[i].classList.contains(this.selectedClass)) { 
                            keywords[i].classList.add(this.selectedClass);
                            this.selectionCounter++;
                        }
                        

                    }

                } else {

                    for (var i = 0; i < keywords.length; i++) {

                        keywords[i].classList.remove(this.selectedClass);
                        this.selectionCounter--;

                    }

                }

                this.updateCounter(this.selectionCounter);
                

            } else {

                event.currentTarget.parentNode.parentNode.parentNode.classList.toggle(this.uncollapseClass);

            }
            

        }

        cancelEditingButtonClickListener(event) {

            this.selectionCounter = 0;

            if (this.editMode) {

                for (let i = 0; i < this.keywords.length; i++) {

                    this.keywords[i].classList.remove(this.selectedClass);
                    
                    if (this.keywords[i].parentNode.classList.contains(this.selectedClass)) this.keywords[i].parentNode.classList.remove(this.selectedClass);
                }

                let editedNarratives = this.tree.querySelectorAll("li.narrative.editing");

                for (let i=0; i< editedNarratives.length; i++) {
                    
                    editedNarratives[i].classList.remove(this.editingClass);
                    editedNarratives[i].getElementsByClassName(this.narrativeText)[0].setAttribute("contenteditable", "false");

                }

            } else {



            }

            this.cancelEditingButton.classList.toggle(this.editingClass);
            this.editMode = !this.editMode;
            this.editKeywordsButton.classList.toggle(this.hiddenClass);
           // alert("edit mode 222")
            $("#editKeywords").removeClass('hidden');
            this.tree.classList.toggle(this.editingClass);
            this.editKeywordsButton.querySelector("div#counter").classList.remove(this.displayedClass);
            // document.querySelector("body").classList.toggle(this.editingClass);

        }

        collapseIconsClickListener(event) {

            event.currentTarget.parentNode.parentNode.parentNode.classList.toggle(this.uncollapseClass);

        }

        notificationsMergeButtonClickListener(event) {

            let keywords = document.querySelectorAll("ul#narrativeTree li.level div#keywordWrapper.selected");

            let text = "";
            for (let i = 0; i < keywords.length; i++) {

                text = text + keywords[i].querySelector("p").textContent + ", ";

            }

            text = text.slice(0, -2);

            keywords[0].querySelector("p").textContent = text;
            keywords[0].classList.add(this.groupClass);
            keywords[0].parentNode.classList.remove(this.uncollapseClass);

            for (let i = 1; i < keywords.length; i++) {

                keywords[i].parentNode.remove();

            }

            this.selectionCounter = 1;
            this.notificationsCounter.textContent = this.selectionCounter;
            this.notificationsMergeButton.classList.remove(this.enabledClass);
            this.notificationsMergeButton.disabled = true;

            keywords[0].scrollIntoView({
                block: "start",
                behavior: "smooth",
              });


        }

        ungroupButtonClickListener(event) {

            let keywords = event.target.previousElementSibling.querySelector("p").textContent.split(', ');
            
            event.target.previousElementSibling.querySelector("p").textContent = keywords[0];
            event.target.parentNode.parentNode.classList.remove(this.uncollapseClass);
            event.target.parentNode.classList.remove(this.groupClass);
            let node = event.target.parentNode.parentNode.querySelectorAll("ul.narratives li.narrative");
            for (let i = 0; i < node.length; i++) {

                node[i].classList.remove(this.openClass);

            }

            for (let i=keywords.length-1; i > 0; i--) {

                let node = event.target.parentNode.parentNode.cloneNode(true);
                
                node.querySelector("p").textContent = keywords[i];
                
                node.querySelector("button#ungroupButton").addEventListener("click", this.ungroupButtonClickListener.bind(this));
                event.target.parentNode.parentNode.after(node);
                event.target.parentNode.parentNode.nextSibling.querySelector("div.keyword").addEventListener("click", this.keywordsClickListener.bind(this));
                event.target.parentNode.parentNode.nextSibling.querySelector("div#keywordWrapper button#radioButton").addEventListener("click", this.radioButtonsClickListener.bind(this));
                let narratives = event.target.parentNode.parentNode.nextSibling.querySelectorAll("ul.narratives li.narrative");
                for (let i = 0; i < narratives.length; i++) {

                    narratives[i].addEventListener("click", this.narrativesClickListener.bind(this));
    
                }
                let posts = event.target.parentNode.parentNode.nextSibling.querySelectorAll("ul.narratives li.narrative div.posts div.post");
                for (let i = 0; i < posts.length; i++) {

                    posts[i].addEventListener("click", this.postsClickListener.bind(this));
    
                }
    
                if (event.target.parentNode.classList.contains(this.selectedClass)) this.selectionCounter++;
                

            }

            this.keywords = document.querySelectorAll("ul#narrativeTree li.level div.keyword");
            this.notificationsCounter.textContent = this.selectionCounter;

            if (this.selectionCounter > 1) {
                
                this.notificationsMergeButton.classList.add(this.enabledClass);
                this.notificationsMergeButton.disabled = false;

            } else {

                this.notificationsMergeButton.classList.remove(this.enabledClass);
                this.notificationsMergeButton.disabled = true;

            }

        }

        notificationsClickListener(event) {

            if (event.target.id == this.closeButton) {

                this.notificationsCloseClickListener();

            }

        }

        notificationsCloseClickListener() {

            this.selectionCounter = 0;

            this.notifications.classList.remove(this.displayedClass);

            for (let i=0; i< this.keywords.length; i++) {

                this.keywords[i].parentNode.classList.remove(this.selectedClass);

            }

        }

        morebuttonClickListener() {

            for (let i = 0; i < this.narratives.length; i++) {

                this.narratives[i].classList.remove(this.hiddenClass);

            }

            this.moreButton[0].previousElementSibling.classList.add(this.lastClass)
            this.moreButton[0].remove();

        }

        keywordsClickListener(event) {

            event.stopPropagation();

            if (this.editMode) {
            	
            	//alert("l mode")
                if (event.currentTarget.classList.contains(this.selectedClass)) {
                	
                	event.currentTarget.classList.add("entity_unselected")
                	event.currentTarget.classList.remove("entity_selected")
                    this.selectionCounter--;

                } else {

                    this.selectionCounter++;
                    event.currentTarget.classList.remove("entity_unselected")
                	event.currentTarget.classList.add("entity_selected")

                }

                event.currentTarget.classList.toggle(this.selectedClass);
                this.updateCounter(this.selectionCounter);

                if (event.currentTarget.parentNode.querySelectorAll("div.keyword.selected").length == event.currentTarget.parentNode.querySelectorAll("div.keyword").length) {
                    event.currentTarget.parentNode.classList.add(this.selectedClass);
                } else {
                    event.currentTarget.parentNode.classList.remove(this.selectedClass);
                }
                    

            } else {
                    
                event.currentTarget.parentNode.parentNode.parentNode.parentNode.classList.toggle(this.uncollapseClass);
            }

        }

        updateCounter(selectionCounter) {

            if ( selectionCounter > 0) {

                this.editKeywordsButton.querySelector("div#counter").textContent = this.selectionCounter;
                this.editKeywordsButton.querySelector("div#counter").classList.add(this.displayedClass);

            } else {

                this.editKeywordsButton.querySelector("div#counter").classList.remove(this.displayedClass);

            }

        }

        radioButtonsClickListener(event) {

            if (event.currentTarget.parentNode.classList.contains(this.selectedClass)) {

                this.selectionCounter--;

            } else {

                this.selectionCounter++;

            }

            if (this.selectionCounter > 1) {
                
                this.notificationsMergeButton.classList.add(this.enabledClass);
                this.notificationsMergeButton.disabled = false;

            } else {

                this.notificationsMergeButton.classList.remove(this.enabledClass);
                this.notificationsMergeButton.disabled = true;

            }

            if (this.selectionCounter < 1) {

                this.notificationsCloseClickListener();

            } else {

                
                event.currentTarget.parentNode.classList.toggle(this.selectedClass);
                this.notifications.classList.add(this.displayedClass);
                this.notificationsCounter.textContent = this.selectionCounter;

            }
            
        }
        


        narrativesClickListener(event) {

console.log(event)
            if (event.target.id == this.narrativeEditButton) {
            	//alert("pdf")
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
                if (this.moreInfoModal.classList.contains(this.displayedClass)) {

                    this.moreInfoCloseButtonClickListener();

                } else  {
                    if (this.editMode) {
                        this.cancelEditingButtonClickListener();
                        
                    }
                    

                }
            } else {

                

            }

        }

    }

    // Initialization

    let general = new General();

});