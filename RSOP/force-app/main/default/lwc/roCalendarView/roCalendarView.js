import { LightningElement, wire, track } from 'lwc';
import fetchData from '@salesforce/apex/roCalendarController.getConnectObjectData';

export default class RoCalendarView extends LightningElement {
    error;
    value = 'Connect Object A';
    tempChild = [];
    tempParent = [];
    parent;
    
    constructor(){
        super();
        fetchData({objectAPINames: ['Connect_Object_A__c'], startDateTimeString : 'dumm', endDateTimeString : 'dummy'})
            .then(result => {
                this.parent = result;
                if (!this.value) {
                    this.value = result.connectorObjectList[0].objectLabel;
                } else {
                    //document.getElementById('selparent').value = this.value;
                }
        
                this.tempParent.length = 0;
                for (var i = 0; i < result.connectorObjectList.length; i++) {
                    if (result.connectorObjectList[i].objectLabel == this.value) {
                        this.tempParent.push(result.connectorObjectList[i])
                    }
                }
                //childData();
                this.load();
            })
            .catch(error => {
                this.error = error;
                alert('error');
                alert(error);
            });
    }

    load() {
        var result = `<div style='width:100%'>`;
        result += `<div style='width:22%;display:inline-block' class="btn-group"><button> <i class='arrow left'></i></button><button> <i class='arrow right'></i></button> <input type='text' style='width:25px'></div>`;
        /*result += `<div style='width:55%;display:inline-block ; text-align:center' >may 9  2020</div>`;
        result += `<div   style='width:22%;display:inline-block; text-align:end' class='btn-group' ><button>day</button> <button>Week</button></div>`;
        result += `</div>`;
        result += `<div class='outer'><div class='inner'><table> `;
        result += `<tr>`;
        var d = 'recordTypes';
        var e = 'sun/5';
        result += `<th class='hard_left'>${d}</th>`;
        result += `<th class='next_left'></th>`;
        result += `<th>${e}</th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th>`;
        result += `<th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th>`;
        result += `</tr>`;
        result += `<tr>`;

        var dropdownvalue = this.getDistinctRecordtype(this.parent.connectorObjectList);
        result += `<th class='hard_left'><select id='selparent' onchange='Display(this.value)'>`;
        result += `<option value=''>Select Type</option>`;
        for (var ddv = 0; ddv < dropdownvalue.length; ddv++) {
            result += `<option value='${dropdownvalue[ddv]}' id='selparento ${dropdownvalue[ddv]}'>${dropdownvalue[ddv]}</option>`;
        }
        result += `</select></th>`;
        result += `<th class='next_left'></th>`;

        result += this.getDayHeaderRow();

        result += `</tr>`;
        for (var p = 0; p < this.tempParent.length; p++) {
            var pr = this.tempParent[p];
            console.log(pr);
            result += `<tr>`;
            for (var c = 0; c <= 25; c++) {
                if (c === 0) {
                    result += `<td class='hard_left'><input type='radio'  value='${pr.objectLabel}'   id='ParentRadio' name='ParentRadio'>${pr.objectData.recordName}</td>`;
                } else if (c === 1) {
                    result += `<td class='next_left'></td>`;
                } else {
                    var startDate = (new Date(pr.objectData.startDateTime)).getUTCHours();
                    var endDateTime = (new Date(pr.objectData.endDateTime)).getUTCHours();
                    var tempVar = c - 2;
                    var backColor = '#fff';
                    result += `<td title=${pr.objectData.description}>${pr.objectData.recordDetail}</td>`;
                    // }
                }
            }
            result += `</tr>`; 
        }


        //result += getChildTable(); //add child table -- pending

        result += `</table></div></div>`;*/
        this.getCanvas();
        this.template.querySelector('div').innerHTML = result;
        /*var child = getchild();
        const grouped = groupBy(child.Resources.ResourceGroup, c => c.ParentGroupname);
        console.log(grouped);*/
    }

    

    

    getDistinctRecordtype(items) {
        var lookup = {};
        var result = [];

        for (var item, i = 0; item = items[i++];) {
            var name = item.objectLabel;
            if (!(name in lookup)) {
                lookup[name] = 1;
                result.push(name);
            }
        }
        return result;
    }

    getDayHeaderRow() {
        var timer = ['am', 'pm']
        var row = '';
        for (var i = 0; i < 2; i++) {
            for (var j = 0; j < 12; j++) {
                if (i == 0) {
                    if (j == 0) {
                        row += `<th>${(j + 12) + timer[0]}</th>`;
                    }
                    else {
                        row += `<th>${j + timer[0]}</th>`;

                    }
                }
                else {
                    if (i == 1 && j == 0) {
                        row += `<th>${(j + 12) + timer[1]}</th>`;
                    } else {
                        row += `<th>${j + timer[1]}</th>`;
                    }
                }
            }
        }
        return row;
    }

    getCanvas() {

        var canvas = this.template.querySelector('canvas');
        var ctx = canvas.getContext('2d');
        ctx.beginPath();
        var arrowSize = 3;
        ctx.lineWidth = arrowSize;

        var fromx = 107;
        var tox = 137; // Every column add 30
        var fromy = 35;
        var toy = 35;
        ctx.moveTo(fromx, fromy);
        ctx.lineTo(tox, toy);
        ctx.strokeStyle = 'red';
        ctx.stroke();

        var fromx = 30;
        var tox = 10;
        var fromy = 50;
        var toy = 50;
        ctx.moveTo(fromx, fromy);
        ctx.lineTo(tox, toy);
        ctx.strokeStyle = 'red';
        ctx.stroke();
    }

}