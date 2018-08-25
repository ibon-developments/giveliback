import {Component, OnInit} from '@angular/core';
import {BooksService} from './services/books.service';
import {ContractsService} from './services/contracts.service';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent implements OnInit {
  booksForm: FormGroup;
  private formSubmitAttempt: boolean;
  constructor(private fb: FormBuilder,
              private contractsService: ContractsService,
              private booksService: BooksService,
              private toastService: ToastrService) {
  }

  ngOnInit() {
    this.buildForm();
  }

  buildForm() {
    this.booksForm = this.fb.group({
      contract: ['', ],
      isbn: ['', [Validators.required, Validators.minLength(5)]],
      bookName: ['', [Validators.required]],
    });
  }
  compileContract() {
    this.contractsService.compileContract().subscribe((data) => {
      if (data) {
        this.booksForm.get('contract').setValue(data[0].contract_address);
      }
    });
  }
  instanceContract() {
    this.contractsService.instanceContract('');
  }
  createBook() {
    this.booksService.createBook(this.booksForm.get('isbn').value, this.booksForm.get('bookName').value).subscribe((data) => {
      if (data) {
        this.toastService.success('Successful operation with creator: ' + data[0].creator +  ' and book name: ' + data[0].book_name);
      } else {
        this.toastService.error('Error in the creation of book');
      }
    });
  }
  getBooksByOwner() {
    this.booksService.getBooksByOwner().subscribe((data) => {
      if (data) {
        this.toastService.success('Successful operation with owner: ' + data[0].owner +  ' and ' + data[0].token_ids.length + ' tokensId' );
      } else {
        this.toastService.error('Error in the search of book');
      }
    });
  }
  lendBook() {
    this.booksService.lendBook('', 12345);
  }
  returnBook() {
    this.booksService.returnBook(12345);
  }
  getBooks() {
    this.booksService.getBooks();
  }
  onSubmit() {
  }
  hasErrors(field: string) {
    return (!this.booksForm.get(field).valid && this.booksForm.get(field).touched) ||
      (this.booksForm.get(field).untouched && this.formSubmitAttempt);
  }
  getError(field: string, validator: string) {
    return this.booksForm.get(field).errors ? this.booksForm.get(field).errors[validator] : false;
  }

}
