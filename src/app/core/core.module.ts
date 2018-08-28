import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {DataService} from './services/data.service';
import {HttpClientModule} from '@angular/common/http';

@NgModule({
  imports: [
    CommonModule,
    HttpClientModule
  ],
  declarations: [],
  providers: [DataService],
})
export class CoreModule { }
