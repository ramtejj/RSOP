import { LightningElement, track, wire  } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = [
    'Resource_Optimizer_Config__mdt.MasterLabel',
    'Resource_Optimizer_Config__mdt.DeveloperName',
    'Resource_Optimizer_Config__mdt.Are_your_Users_are_Resources__c',
    'Resource_Optimizer_Config__mdt.Do_you_allow_Overlay__c',
    'Resource_Optimizer_Config__mdt.Do_you_allow_skill_based__c',
    'Resource_Optimizer_Config__mdt.Do_you_need_Resource_Grouping__c',
    'Resource_Optimizer_Config__mdt.Organisation_business_hours_end_time__c',
    'Resource_Optimizer_Config__mdt.Organisation_business_hours_start_time__c',
    'Resource_Optimizer_Config__mdt.Select_Profiles_to_create_Resources__c'
];

export default class ResourceOptimizerSetupAssistant extends LightningElement {

    recordId='m001s00000004Ii';
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    metadatarecord;
    
    @track _selected = [];

    get options() {
        return [
            { label: 'English', value: 'en' },
            { label: 'German', value: 'de' },
            { label: 'Spanish', value: 'es' },
            { label: 'French', value: 'fr' },
            { label: 'Italian', value: 'it' },
            { label: 'Japanese', value: 'ja' },
        ];
    }

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
    }
}