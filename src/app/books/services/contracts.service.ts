import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {DataService} from '../../core/services/data.service';

@Injectable({
  providedIn: 'root'
})
export class ContractsService {

  constructor(private dataService: DataService) {
  }
  compileContract() {
    this.dataService.get('http://127.0.0.1:8888/compile_contracts').subscribe((data) => {
      if (data) {
       console.log(data.contract_address);
      }
    });
  }
}
