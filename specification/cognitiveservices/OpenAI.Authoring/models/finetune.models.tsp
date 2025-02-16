import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.Core;

namespace Azure.OpenAI;

@doc("Fine tuning is a job to tailor a model to specific training data.")
@resource("fine-tunes")
model FineTune {
  @doc("Defines the type of an object.")
  @visibility("read")
  object?: TypeDiscriminator;

  @doc("The state of a job or item.")
  @visibility("read")
  status?: State;

  @doc("A timestamp when this job or item was created (in unix epochs).")
  @visibility("read")
  created_at?: int32;

  @doc("A timestamp when this job or item was modified last (in unix epochs).")
  @visibility("read")
  updated_at?: int32;

  @doc("The identity of this item.")
  @visibility("read")
  @key("fineTuneId")
  id: string;

  @doc("The identifier of the base model used for the fine-tune.")
  "model": string;

  @doc("""
The identifier of the resulting fine tuned model. This property is only
populated for successfully completed fine-tune runs.
Use this identifier to
create a deployment for inferencing.
""")
  @visibility("read")
  fine_tuned_model?: string;

  @doc("The files that are used for training the fine tuned model.")
  training_files: File[];

  @doc("The files that are used to evaluate the fine tuned model during training.")
  validation_files?: File[];

  @doc("""
The result files containing training and evaluation metrics in csv format.
The
file is only available for successfully completed fine-tune runs.
""")
  @visibility("read")
  result_files?: File[];

  @doc("""
The events that show the progress of the fine-tune run including queued,
running and completed.
""")
  @visibility("read")
  events?: Event[];

  @doc("""
The organisation id of this fine tune job. Unused on Azure OpenAI;
compatibility for OpenAI only.
""")
  @visibility("read")
  organisation_id?: string;

  @doc("""
The user id of this fine tune job. Unused on Azure OpenAI; compatibility for
OpenAI only.
""")
  @visibility("read")
  user_id?: string;

  @doc("The hyper parameter settings used in a fine tune job.")
  hyperparams?: HyperParameters;
}

@doc("Event")
model Event {
  @doc("Defines the type of an object.")
  @visibility("read")
  object?: TypeDiscriminator;

  @doc("A timestamp when this event was created (in unix epochs).")
  @visibility("read")
  created_at?: int32;

  @doc("The verbosity level of an event.")
  @visibility("read")
  level?: LogLevel;

  @doc("""
The message describing the event. This can be a change of state, e.g.,
enqueued, started, failed or completed, or other events like uploaded results.
""")
  @visibility("read")
  message?: string;
}

@doc("The hyper parameter settings used in a fine tune job.")
model HyperParameters {
  @doc("""
The batch size to use for training. The batch size is the number of training
examples used to train a single forward and backward pass.
In general, we've
found that larger batch sizes tend to work better for larger datasets.
The
default value as well as the maximum value for this property are specific to a
base model.
""")
  batch_size?: int32;

  @doc("""
The learning rate multiplier to use for training. The fine-tuning learning rate
is the original learning rate used for pre-training multiplied by this
value.
Larger learning rates tend to perform better with larger batch
sizes.
We recommend experimenting with values in the range 0.02 to 0.2 to see
what produces the best results.
""")
  learning_rate_multiplier?: float32;

  @doc("""
The number of epochs to train the model for. An epoch refers to one full cycle
through the training dataset.
""")
  n_epochs?: int32;

  @doc("""
The weight to use for loss on the prompt tokens. This controls how much the
model tries to learn to generate the prompt
(as compared to the completion
which always has a weight of 1.0), and can add a stabilizing effect to training
when completions are short.
If prompts are extremely long (relative to
completions), it may make sense to reduce this weight so as to avoid
over-prioritizing learning the prompt.
""")
  prompt_loss_weight?: float32;

  @doc("""
A value indicating whether to compute classification metrics.
If set, we
calculate classification-specific metrics such as accuracy and F-1 score using
the validation set at the end of every epoch.
These metrics can be viewed in
the results file. In order to compute classification metrics, you must provide
a validation_file.Additionally,
you must specify classification_n_classes for
multiclass classification or classification_positive_class for binary
classification.
""")
  compute_classification_metrics?: boolean;

  @doc("""
The number of classes in a classification task.
This parameter is required for
multiclass classification.
""")
  classification_n_classes?: int32;

  @doc("""
The positive class in binary classification.
This parameter is needed to
generate precision, recall, and F1 metrics when doing binary classification.
""")
  classification_positive_class?: string;

  @doc("""
The classification beta values. If this is provided, we calculate F-beta scores
at the specified beta values.
The F-beta score is a generalization of F-1
score. This is only used for binary classification.
With a beta of 1 (i.e.the
F-1 score), precision and recall are given the same weight.
A larger beta
score puts more weight on recall and less on precision. A smaller beta score
puts more weight on precision and less on recall.
""")
  classification_betas?: float32[];
}

@doc("Defines the values of a fine tune job.")
model FineTuneCreation {
  @doc("The identifier of the base model used for this fine-tune.")
  "model": string;

  @doc("The file that is used for training this fine tuned model.")
  training_file: string;

  @doc("The file that is used to evaluate the fine tuned model during training.")
  validation_file?: string;

  @doc("The hyper parameter settings used in a fine tune job.")
  hyperparams?: HyperParameters;
}
