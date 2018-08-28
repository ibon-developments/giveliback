import {Injectable} from '@angular/core';
import {DataService} from '../../core/services/data.service';
import {HttpParams} from '@angular/common/http';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class BooksService {

  constructor(private dataService: DataService) {
  }
  createBook(isbn: string, bookName: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('isbn', isbn.toString());
    params = params.append('book_name', bookName);
    return this.dataService.getWithParameters('http://127.0.0.1:8888/create_book', params);
  }
  getBooksByOwner(): Observable <any> {
    return this.dataService.get('http://127.0.0.1:8888/get_books_by_owner');
  }
  lendBook(toAddress: string, tokenId: number): Observable<any> {
    let params = new HttpParams();
    params = params.append('to', toAddress);
    params = params.append('tokenId', tokenId.toString());
    return this.dataService.getWithParameters('http://127.0.0.1:8888/lend_book', params);
  }
  returnBook(tokenId: number): Observable<any> {
    let params = new HttpParams();
    params = params.append('tokenId', tokenId.toString());
    return this.dataService.getWithParameters('http://127.0.0.1:8888/return_book', params);
  }
}
