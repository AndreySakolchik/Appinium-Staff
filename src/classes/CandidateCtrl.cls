public with sharing class CandidateCtrl {

	public Attachment attachedFilePhoto {get; set;}
	public Attachment attachedFile {get; set;}
	public Candidate__c candidate {get; set;}
	
	public List<SelectOption> allVacancies {get; set;}
	public List<String> selectedVacanciesRight {get; set;}
	public List<String> selectedVacanciesLeft {get; set;}
	public List<SelectOption> chosenVacancies {get; set;}
	public List<SelectOption> allSkills {get; set;}
	public List<String> selectedSkillsRight {get; set;}
	public List<String> selectedSkillsLeft {get; set;}
	public List<SelectOption> chosenSkills {get; set;}
	public List<Skill__c> skills {get; set;}
	public List<Vacancy__c> vacancies {get; set;}

	public CandidateCtrl() {
		this.attachedFilePhoto = new Attachment();
		this.candidate = new Candidate__c();
		this.attachedFile = new Attachment();
		this.allSkills = new List<SelectOption>();
		this.allVacancies = new List<SelectOption>();
		this.chosenVacancies = new List<SelectOption>();
		this.chosenSkills = new List<SelectOption>();
		this.selectedSkillsLeft = new List<String>();
		this.selectedSkillsRight = new List<String>();
		this.selectedVacanciesLeft = new List<String>();
		this.selectedVacanciesRight = new List<String>();
		this.skills = new List<Skill__c>();
		this.vacancies = new List<Vacancy__c>();
		
	}

	public void init() {

		skills = [
			SELECT Name 
			FROM Skill__c];
		if(!skills.isEmpty()) {
				for(Skill__c current : skills) {
					allSkills.add(new SelectOption(current.Name, current.Name));
				}
		}

		vacancies = [
			SELECT Name 
			FROM Vacancy__c];
		if(!vacancies.isEmpty()) {
			for(Vacancy__c current : vacancies) {
				allVacancies.add(new SelectOption(current.Name, current.Name));
			}
		}
	}

	public void save() {

		candidate.HR_Manager__c = Userinfo.GetUserId();
		insert candidate;

		if(attachedFile.Name != null) {
			attachedFile.ParentId = candidate.ID;
			insert attachedFile;
		}

		if(!this.chosenSkills.isEmpty()) {
			for(SelectOption so : this.chosenSkills) {
				for(Skill__c sk : this.skills) {
					if(so.getValue() == sk.Name) {
						CandidateSkill__c junk = new CandidateSkill__c();
						junk.Candidate__c = candidate.ID;
						junk.Skill__c = sk.ID;
						insert junk;
					}
				}
			}
		}

		if(!this.chosenVacancies.isEmpty()) {
			for(SelectOption so : this.chosenVacancies) {
				for(Vacancy__c vc : this.vacancies) {
					if(so.getValue() == vc.Name) {
						VacancyCandidate__c junk = new VacancyCandidate__c();
						junk.Candidate__c = candidate.ID;
						junk.Vacancy__c = vc.ID;
						insert junk;
					}
				}
			}
		}
	}
	

	public void MoveRightSkills() {

		for(String line : this.selectedSkillsRight) {
			this.chosenSkills.add(new SelectOption(line, line));
			for(Integer i = 0; i < this.allSkills.size(); i++) {
				if(this.allSkills[i].getValue() == line) {
					this.allSkills.remove(i);
				}
			}
		}
	}


	public void MoveLeftSkills() {

		for(String line : this.selectedSkillsLeft) {
			this.allSkills.add(new SelectOption(line, line));
			for(Integer i = 0; i < this.chosenSkills.size(); i++) {
				if(this.chosenSkills[i].getValue() == line) {
					this.chosenSkills.remove(i);
				}
			}
		}
	}

	public void MoveRightVacancies() {

		for(String line : this.selectedVacanciesRight) {
			this.chosenVacancies.add(new SelectOption(line, line));
			for(Integer i = 0; i < this.allVacancies.size(); i++) {
				if(this.allVacancies[i].getValue() == line) {
					this.allVacancies.remove(i);
				}
			}
		}
	}

	public void MoveLeftVacancies() {

		for(String line : this.selectedVacanciesLeft) {
			this.allVacancies.add(new SelectOption(line, line));
			for(Integer i = 0; i < this.chosenVacancies.size(); i++) {
				if(this.chosenVacancies[i].getValue() == line) {
					this.chosenVacancies.remove(i);
				}
			}
		}
	}
	
	public void doAttachedPhoto () {
		
		save();
		
		//this.attachedFilePhoto.name = 'PhotoCandidate.jpg';
		//this.attachedFilePhoto.ParentId = this.candidate.ID;
		//this.attachedFilePhoto.body = Blob.valueOf(Apexpages.currentPage().getParameters().get('myParam'));
		//insert attachedFilePhoto;
		
	}
}