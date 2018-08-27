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
      contract: [''],
      isbn: [''],
      bookName: [''],
      receiverAddress: [''],
      tokenId: [''],
    });
  }
  compileContract() {
    this.contractsService.compileContract().subscribe((data) => {
      if (data) {
        this.booksForm.get('contract').setValue(data[0].contract_address);
        this.toastService.success('Successfully deployed contract');
      } else {
        this.toastService.error('Error deployed contract');
      }
    });
  }
  createBook() {
    this.booksService.createBook(this.booksForm.get('isbn').value, this.booksForm.get('bookName').value).subscribe((data) => {
      if (data) {
        this.toastService.success('Successful operation with creator ' + data[0].creator +  ' and book name ' + data[0].book_name);
      } else {
        this.toastService.error('Error in the creation of book');
      }
    });
  }
  getBooksByOwner() {
    this.booksService.getBooksByOwner().subscribe((data) => {
      if (data) {
        this.toastService.success('Successful operation with owner ' + data[0].owner +  ' and ' + data[0].token_ids.length + ' tokensId' );
      } else {
        this.toastService.error('Error in the search of book');
      }
    });
  }
  lendBook() {
    this.booksService.lendBook(this.booksForm.get('receiverAddress').value, this.booksForm.get('tokenId').value).subscribe((data) => {
      if (data) {
        this.toastService.success('Successful lend book');
      } else {
        this.toastService.error('Error in the lend of book');
      }
    });
  }
  returnBook() {
    this.booksService.returnBook(this.booksForm.get('tokenId').value).subscribe((data) => {
      if (data) {
        this.toastService.success('Successful return book with issuer ' + data[0].issuer +  ' and token id ' + data[0].token_id);
      } else {
        this.toastService.error('Error in the return of book');
      }
    });
  }

}
