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
}
