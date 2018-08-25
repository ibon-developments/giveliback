import {Injectable} from '@angular/core';
import {HttpParams} from '@angular/common/http';
import {DataService} from '../../core/services/data.service';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ContractsService {

  constructor(private dataService: DataService) {
  }
  compileContract(): Observable<any> {
    return this.dataService.get('http://127.0.0.1:8888/compile_contracts');
  }
  instanceContract(contractAddress: string) {
    let params = new HttpParams();
    params = params.append('contract_address', contractAddress);
    this.dataService.getWithParameters('http://127.0.0.1:8888/manual_instance', params).subscribe((data) => {
      if (data) {
        console.log(data);
      }
    });
  }
}
