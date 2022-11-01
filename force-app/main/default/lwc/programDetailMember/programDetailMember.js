import { LightningElement, api, wire } from 'lwc';
import  getPrograms from '@salesforce/apex/TDOC_ProgramDetailMemberController.getPrograms';
import  updatePrograms from '@salesforce/apex/TDOC_ProgramDetailMemberController.updatePrograms';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import PROGRAM_STATUS_FIELD from '@salesforce/schema/Program__c.Status__c';
import PROGRAM_OBJECT from '@salesforce/schema/Program__c';
import 	MSG_SUCCESS  from '@salesforce/label/c.Success_Update_Records';

export default class ProgramDetailMember extends LightningElement {
	@api recordId;
	programs;
	programStatus;
	error;
	

	@wire(getObjectInfo, { objectApiName: PROGRAM_OBJECT })
	objectInfo;
	
	@wire(getPicklistValues, {
		recordTypeId: "$objectInfo.data.defaultRecordTypeId",
		fieldApiName: PROGRAM_STATUS_FIELD
	})getProgramStatus({ error, data }) {
		if (data) {
			this.programStatus = data.values;
			console.log(data);
		} else if (error) {
			this.error = error;
			this.record = undefined;
		}
	}

	connectedCallback(){
		getPrograms({contactId: this.recordId})
		.then(result => {
			this.programs = result;
			this.error = undefined;
		})
		.catch(error => {
			this.error = error;
			this.programs = undefined;
		});
	}

	savePrograms(event) {
		let programStatus = this.template.querySelectorAll("lightning-combobox");
		let i=0;
		let programList = [];
		
		this.programs.forEach(item => {
			let program = {
				Id: item.Id,
				Name: item.Name,
				Status__c: programStatus[i].value
			};
			programList.push(program);
			i++;
		});
		
		updatePrograms({programs: programList})
			.then(result => {
				if(result === 'SUCCESS'){
					const evt = new ShowToastEvent({
						title: MSG_SUCCESS,
						variant: 'success',
						mode: 'dismissable'
					});
					this.dispatchEvent(evt);
				}
			})
			.catch(error => {
				this.error = error;
			});

		//showSuccessToast();
	}

	showSuccessToast() {
        const evt = new ShowToastEvent({
            title: 'Toast Success',
            message: 'Opearion sucessful',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}